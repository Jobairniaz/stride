"""Generates the spoken phase-change notification sounds.

When Stride is in the background its Dart timer (and therefore live TTS) is
suspended, so the scheduled phase-change notifications carry the voice
instead: each one plays a short spoken clip as its notification sound.

Clips are rendered with macOS `say` and converted with `afconvert` (both
built into macOS), then written to:

* android/app/src/main/res/raw/<name>.wav   (notification channel sounds)
* ios/Runner/<name>.caf                     (bundled; listed in project.pbxproj)

PLACEHOLDER VOICE: Apple's macOS licence limits system-voice output to
personal, non-commercial use. Replace these clips (e.g. record your own,
same names, short and loud) before shipping. To swap in recordings, put
<name>.wav/.aiff/.m4a files in tool/cue_recordings/ and re-run: they are used
instead of `say`.

Run from the project root:  python3 tool/generate_cue_sounds.py
"""

import array
import subprocess
import tempfile
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RECORDINGS = ROOT / "tool/cue_recordings"
ANDROID_RAW = ROOT / "android/app/src/main/res/raw"
IOS_DIR = ROOT / "ios/Runner"

# Keep in sync with CueSound in
# lib/platform/notifications/workout_notification_service.dart.
CLIPS = {
    "cue_walk": "Start walking",
    "cue_run": "Start running",
    "cue_rest": "Rest time",
    "cue_finish": "Workout completed",
}

VOICE = "Samantha"
RATE_WPM = 185
SAMPLE_RATE = 22050
LEAD_IN_S = 0.25  # lets the music duck before the first syllable
TAIL_S = 0.10
PEAK = 0.89  # about -1 dBFS


def run(*cmd):
    subprocess.run(cmd, check=True, capture_output=True)


def to_pcm(src: Path, dst: Path):
    """Any audio file -> 16-bit mono WAV at SAMPLE_RATE."""
    run("afconvert", "-f", "WAVE", "-d", f"LEI16@{SAMPLE_RATE}", "-c", "1",
        str(src), str(dst))


def tidy(path: Path):
    """Trims silence, normalises the peak and adds a short lead-in/tail."""
    with wave.open(str(path), "rb") as w:
        samples = array.array("h", w.readframes(w.getnframes()))
    gate = 300
    loud = [i for i, s in enumerate(samples) if abs(s) > gate]
    samples = samples[loud[0]:loud[-1] + 1]
    gain = PEAK * 32767 / max(abs(s) for s in samples)
    samples = array.array(
        "h", (max(-32768, min(32767, round(s * gain))) for s in samples))
    out = (array.array("h", [0]) * round(LEAD_IN_S * SAMPLE_RATE)
           + samples
           + array.array("h", [0]) * round(TAIL_S * SAMPLE_RATE))
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SAMPLE_RATE)
        w.writeframes(out.tobytes())


def recording_for(name: str):
    if not RECORDINGS.is_dir():
        return None
    return next(iter(sorted(RECORDINGS.glob(f"{name}.*"))), None)


def main():
    ANDROID_RAW.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        for name, text in CLIPS.items():
            src = recording_for(name)
            if src is None:
                src = Path(tmp) / f"{name}.aiff"
                run("say", "-v", VOICE, "-r", str(RATE_WPM), "-o", str(src), text)
            wav = ANDROID_RAW / f"{name}.wav"
            to_pcm(src, wav)
            tidy(wav)
            caf = IOS_DIR / f"{name}.caf"
            run("afconvert", "-f", "caff", "-d", "LEI16", str(wav), str(caf))
            with wave.open(str(wav), "rb") as w:
                secs = w.getnframes() / w.getframerate()
            origin = "recording" if src.parent == RECORDINGS else f"say -v {VOICE}"
            print(f"{name:<11} {secs:4.2f}s  \"{text}\"  ({origin})")


if __name__ == "__main__":
    main()
