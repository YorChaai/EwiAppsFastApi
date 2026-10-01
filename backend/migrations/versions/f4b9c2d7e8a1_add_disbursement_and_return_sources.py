"""add disbursement and return source fields

Revision ID: f4b9c2d7e8a1
Revises: ae69a3c66bb1
Create Date: 2026-05-10 16:55:00.000000

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "f4b9c2d7e8a1"
down_revision = "ae69a3c66bb1"
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table("advances", schema=None) as batch_op:
        batch_op.add_column(
            sa.Column("disbursement_source", sa.String(length=50), nullable=True)
        )
        batch_op.add_column(
            sa.Column("return_source", sa.String(length=50), nullable=True)
        )

    with op.batch_alter_table("settlements", schema=None) as batch_op:
        batch_op.add_column(
            sa.Column("disbursement_source", sa.String(length=50), nullable=True)
        )
        batch_op.add_column(
            sa.Column("return_source", sa.String(length=50), nullable=True)
        )


def downgrade():
    with op.batch_alter_table("settlements", schema=None) as batch_op:
        batch_op.drop_column("return_source")
        batch_op.drop_column("disbursement_source")

    with op.batch_alter_table("advances", schema=None) as batch_op:
        batch_op.drop_column("return_source")
        batch_op.drop_column("disbursement_source")
