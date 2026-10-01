import os
import shutil
import uuid
from config import Config

def allowed_file(filename):
    allowed = Config.ALLOWED_EXTENSIONS
    return "." in filename and filename.rsplit(".", 1)[1].lower() in allowed

def handle_profile_image_upload(user, file) -> bool:
    """
    Handles saving of a new profile image. Deletes the old one if exists.
    Returns True if successful.
    """
    if not file or not file.filename or not allowed_file(file.filename):
        return False
        
    ext = file.filename.rsplit(".", 1)[1].lower()
    unique_name = f"profile_{user.id}_{uuid.uuid4().hex[:8]}.{ext}"

    upload_dir = os.path.join(Config.UPLOAD_FOLDER, "profiles")
    os.makedirs(upload_dir, exist_ok=True)

    # Delete old image if exists
    if user.profile_image:
        old_path = os.path.join(
            Config.UPLOAD_FOLDER, user.profile_image
        )
        if os.path.exists(old_path):
            try:
                os.remove(old_path)
            except Exception:
                pass

    source = getattr(file, "file", None) or getattr(file, "stream", None)
    if source is None and hasattr(file, "save"):
        file.save(os.path.join(upload_dir, unique_name))
    else:
        source.seek(0)
        with open(os.path.join(upload_dir, unique_name), "wb") as target:
            shutil.copyfileobj(source, target)
    user.profile_image = f"profiles/{unique_name}"
    return True

def handle_profile_image_removal(user):
    """
    Removes the user's current profile image from storage.
    """
    if user.profile_image:
        old_path = os.path.join(
            Config.UPLOAD_FOLDER, user.profile_image
        )
        if os.path.exists(old_path):
            try:
                os.remove(old_path)
            except Exception:
                pass
        user.profile_image = None
