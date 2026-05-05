from datetime import datetime

from .base import Base
from .mixins.id_int_pk import IdIntPk
from .mixins.time_stamp_mixin import TimestampMixin
from sqlalchemy import DateTime, ForeignKey, Integer, String, UniqueConstraint

from sqlalchemy.orm import Mapped, mapped_column, relationship


class Attendance(Base, IdIntPk, TimestampMixin):
    __tablename__ = "attendances"
    __table_args__ = (
        UniqueConstraint("enter_camera_id", "enter_rec_no", name="uq_attendances_enter_cam_rec"),
        UniqueConstraint("exit_camera_id",  "exit_rec_no",  name="uq_attendances_exit_cam_rec"),
    )

    employee_id: Mapped[int] = mapped_column(
        ForeignKey("employees.id"), nullable=False, index=True
    )

    # Вход
    enter_camera_id: Mapped[int | None] = mapped_column(
        ForeignKey("cameras.id"), nullable=True
    )
    enter_time: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, index=True
    )
    enter_rec_no: Mapped[int | None] = mapped_column(
        Integer, nullable=True, index=True
    )

    # Выход
    exit_camera_id: Mapped[int | None] = mapped_column(
        ForeignKey("cameras.id"), nullable=True
    )
    exit_time: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, index=True
    )
    exit_rec_no: Mapped[int | None] = mapped_column(
        Integer, nullable=True, index=True
    )

    status: Mapped[str] = mapped_column(String(50), nullable=False)

    presence_status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="absent", index=True
    )

    employee = relationship("Employee", back_populates="attendances")
    enter_camera = relationship("Camera", foreign_keys=[enter_camera_id])
    exit_camera = relationship("Camera", foreign_keys=[exit_camera_id])