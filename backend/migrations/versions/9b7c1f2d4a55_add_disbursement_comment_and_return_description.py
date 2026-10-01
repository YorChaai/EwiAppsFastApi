"""add disbursement_comment and return_description to advances and settlements

Revision ID: 9b7c1f2d4a55
Revises: 1c018e4753ce
Create Date: 2026-05-19 00:00:00.000000

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "9b7c1f2d4a55"
down_revision = "1c018e4753ce"
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table("advances", schema=None) as batch_op:
        batch_op.add_column(sa.Column("disbursement_comment", sa.Text(), nullable=True))
        batch_op.add_column(sa.Column("return_description", sa.Text(), nullable=True))

    with op.batch_alter_table("settlements", schema=None) as batch_op:
        batch_op.add_column(sa.Column("disbursement_comment", sa.Text(), nullable=True))
        batch_op.add_column(sa.Column("return_description", sa.Text(), nullable=True))


def downgrade():
    with op.batch_alter_table("settlements", schema=None) as batch_op:
        batch_op.drop_column("return_description")
        batch_op.drop_column("disbursement_comment")

    with op.batch_alter_table("advances", schema=None) as batch_op:
        batch_op.drop_column("return_description")
        batch_op.drop_column("disbursement_comment")
