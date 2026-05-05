CREATE TYPE camera_type AS ENUM ('enter', 'exit');

CREATE TABLE employees (
    id              SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    middle_name     VARCHAR(50)  NOT NULL,
    camera_user_id  VARCHAR(50)  UNIQUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX ix_employees_camera_user_id ON employees (camera_user_id);

CREATE TABLE cameras (
    id          SERIAL PRIMARY KEY,
    ip_address  VARCHAR(50)  NOT NULL,
    login       VARCHAR(50)  NOT NULL,
    password    VARCHAR(100) NOT NULL,
    type        camera_type  NOT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE attendances (
    id              SERIAL PRIMARY KEY,
    employee_id     INTEGER     NOT NULL REFERENCES employees(id),
    enter_camera_id INTEGER     REFERENCES cameras(id),
    enter_time      TIMESTAMPTZ,
    enter_rec_no    INTEGER,
    exit_camera_id  INTEGER     REFERENCES cameras(id),
    exit_time       TIMESTAMPTZ,
    exit_rec_no     INTEGER,
    status          VARCHAR(50) NOT NULL,
    presence_status VARCHAR(20) NOT NULL DEFAULT 'absent',
    created_at      TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_attendances_enter_cam_rec UNIQUE (enter_camera_id, enter_rec_no),
    CONSTRAINT uq_attendances_exit_cam_rec  UNIQUE (exit_camera_id,  exit_rec_no)
);

CREATE INDEX ix_attendances_employee_id      ON attendances (employee_id);
CREATE INDEX ix_attendances_enter_time       ON attendances (enter_time);
CREATE INDEX ix_attendances_exit_time        ON attendances (exit_time);
CREATE INDEX ix_attendances_enter_rec_no     ON attendances (enter_rec_no);
CREATE INDEX ix_attendances_exit_rec_no      ON attendances (exit_rec_no);
CREATE INDEX ix_attendances_presence_status  ON attendances (presence_status);
