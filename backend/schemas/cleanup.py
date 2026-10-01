from pydantic import BaseModel, Field


class CleanupRequest(BaseModel):
    years: list[int | str] = Field(default_factory=list)
    modules: list[str] = Field(default_factory=list)
