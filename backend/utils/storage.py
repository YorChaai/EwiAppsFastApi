from pathlib import Path

from config import Config


def delete_evidence_file(file_path):
    """Delete stored evidence paths while keeping deletion inside upload storage."""
    if not file_path:
        return False

    root = Path(Config.UPLOAD_FOLDER).resolve()
    success = True
    for item in str(file_path).split("|"):
        item = item.strip()
        if not item:
            continue
        relative = Path(item.replace("\\", "/"))
        if relative.is_absolute() or ".." in relative.parts:
            success = False
            continue
        target = (root / relative).resolve()
        if root not in target.parents:
            success = False
            continue
        try:
            target.unlink(missing_ok=True)
        except OSError:
            success = False
    return success
