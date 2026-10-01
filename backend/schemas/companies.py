from pydantic import BaseModel, Field


class CompanyPayload(BaseModel):
    name: str = Field(min_length=1, max_length=100)


class CompanyOrderItem(BaseModel):
    id: int


class CompanyOrderPayload(BaseModel):
    companies: list[CompanyOrderItem]
