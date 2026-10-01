from app import create_app
from extensions import db
from models import User
from werkzeug.security import generate_password_hash

def create_users():
app = create_app()
with app.app_context(): # Define the users to create/update
users_data = [
{
"username": "supermanager",
"email": "supermanager@example.com",
"full_name": "Super Manager 1",
"role": "super_manager",
"password_plain": "12345super"
},
{
"username": "manager1",
"email": "manager1@example.com",
"full_name": "Manager 1",
"role": "manager",
"password_plain": "67890manager"
},
{
"username": "manager2",
"email": "manager2@example.com",
"full_name": "Manager 2",
"role": "manager",
"password_plain": "manager123"
},
{
"username": "staff",
"email": "staff@example.com",
"full_name": "Staff 1",
"role": "staff",
"password_plain": "staff123"
},
{
"username": "mitra",
"email": "mitra@example.com",
"full_name": "Mitra 1",
"role": "mitra",
"password_plain": "mitra123"
}
]

        for data in users_data:
            user = User.query.filter_by(username=data["username"]).first()
            if user:
                # Update existing
                user.password_hash = generate_password_hash(data["password_plain"])
                user.role = data["role"]
                user.full_name = data["full_name"]
            else:
                # Create new
                user = User(
                    username=data["username"],
                    email=data["email"],
                    full_name=data["full_name"],
                    role=data["role"],
                    password_hash=generate_password_hash(data["password_plain"])
                )
                db.session.add(user)

        try:
            db.session.commit()
            print("Users successfully created/updated!")
        except Exception as e:
            db.session.rollback()
            print(f"Failed to create users: {e}")

if **name** == "**main**":
create_users()
