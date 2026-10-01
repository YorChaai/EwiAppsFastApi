from pydantic import BaseModel


class ReportYearUpdate(BaseModel):
    default_report_year: int | str | None = None
