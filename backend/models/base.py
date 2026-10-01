import os
from sqlalchemy import (
    Column, Integer, String, Text, Float, Numeric, Boolean, DateTime, Date, JSON,
    ForeignKey, Table, MetaData, func, or_, and_, not_, exists, cast, desc, asc, case
)
from sqlalchemy.orm import relationship, backref, DeclarativeBase, joinedload, selectinload
from core.database import Base, db_session, engine

class SQLAlchemyAdapter:
    Model = Base
    Column = Column
    Integer = Integer
    String = String
    Text = Text
    Float = Float
    Numeric = Numeric
    Boolean = Boolean
    DateTime = DateTime
    Date = Date
    JSON = JSON
    ForeignKey = ForeignKey
    Table = Table
    relationship = staticmethod(relationship)
    backref = staticmethod(backref)
    joinedload = staticmethod(joinedload)
    selectinload = staticmethod(selectinload)
    session = db_session
    func = func
    or_ = staticmethod(or_)
    and_ = staticmethod(and_)
    not_ = staticmethod(not_)
    exists = staticmethod(exists)
    cast = staticmethod(cast)
    desc = staticmethod(desc)
    asc = staticmethod(asc)
    case = staticmethod(case)

    @property
    def engine(self):
        from core.database import get_engine
        return get_engine()

    def create_all(self, bind=None):
        Base.metadata.create_all(bind=bind or self.engine)

    def drop_all(self, bind=None):
        Base.metadata.drop_all(bind=bind or self.engine)

db = SQLAlchemyAdapter()

# Association tables for Multi-Subcategory support
expense_subcategories = Table(
    "expense_subcategories",
    Base.metadata,
    Column("expense_id", Integer, ForeignKey("expenses.id"), primary_key=True),
    Column("category_id", Integer, ForeignKey("categories.id"), primary_key=True),
)

advance_item_subcategories = Table(
    "advance_item_subcategories",
    Base.metadata,
    Column("advance_item_id", Integer, ForeignKey("advance_items.id"), primary_key=True),
    Column("category_id", Integer, ForeignKey("categories.id"), primary_key=True),
)
