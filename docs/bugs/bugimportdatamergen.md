# bug di backend 
(venv) D:\Aplikasi\EWIApps\backend>python app.py
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.68.51:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 539-689-693
192.168.68.51 - - [19/May/2026 14:57:25] "GET /api/notifications?read_status=all&limit=50&offset=0 HTTP/1.1" 200 -
192.168.68.51 - - [19/May/2026 14:57:34] "POST /api/settings/db/import-preview HTTP/1.1" 200 -
[*] Pre-import backup saved to: ../data\Database\Backups\2026-05-19_14-57-35(import)\backup_data_lama_sebelum_import_2026-05-19_14-57-35.sql
[*] Memulai Restore PostgreSQL dari file: ../data\tmp\temp_import.sql
[*] Koneksi internal dilepaskan untuk menghindari deadlock.
[*] Membersihkan schema public lama...
[*] Menjalankan perintah psql restore...
[*] Restore Selesai. Melakukan verifikasi data...
[+] Verifikasi Berhasil: Ditemukan 5 User dan 155 Pengeluaran di database baru.
192.168.68.51 - - [19/May/2026 14:57:35] "POST /api/settings/db/import-confirm HTTP/1.1" 200 -
[SETTLEMENT_API] ===== REQUEST =====
[SETTLEMENT_API] user_id=1, role=manager
[SETTLEMENT_API] status_filter=None
[SETTLEMENT_API] report_year=2031, mode=report
[SETTLEMENT_API] search_query=
[SETTLEMENT_API] Filtering year=2031 with mode=report
192.168.68.51 - - [19/May/2026 14:57:35] "GET /api/settlements?report_year=2031&mode=report HTTP/1.1" 500 -
Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
psycopg2.errors.UndefinedColumn: column settlements.disbursement_comment does not exist
LINE 1: ...s.returned_amount AS settlements_returned_amount, settlement...
                                                             ^


The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py", line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\settlements.py", line 172, in list_settlements
    settlements = query.order_by(Settlement.created_at.asc(), Settlement.id.asc()).all()
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2704, in all
    return self._iter().all()  # type: ignore
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2857, in _iter
    result: Union[ScalarResult[_T], Result[_T]] = self.session.execute(
                                                  ^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2351, in execute
    return self._execute_internal(
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2249, in _execute_internal
    result: Result[Any] = compile_state_cls.orm_execute_statement(
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\context.py", line 306, in orm_execute_statement
    result = conn.execute(
             ^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1419, in execute
    return meth(
           ^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\sql\elements.py", line 527, in _execute_on_connection
    return connection._execute_clauseelement(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1641, in _execute_clauseelement
    ret = self._execute_context(
          ^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1846, in _execute_context
    return self._exec_single_context(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1986, in _exec_single_context
    self._handle_dbapi_exception(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 2363, in _handle_dbapi_exception
    raise sqlalchemy_exception.with_traceback(exc_info[2]) from e
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
sqlalchemy.exc.ProgrammingError: (psycopg2.errors.UndefinedColumn) column settlements.disbursement_comment does not exist
LINE 1: ...s.returned_amount AS settlements_returned_amount, settlement...
                                                             ^

[SQL: SELECT settlements.id AS settlements_id, settlements.title AS settlements_title, settlements.description AS settlements_description, settlements.user_id AS settlements_user_id, settlements.settlement_type AS settlements_settlement_type, settlements.status AS settlements_status, settlements.report_year AS settlements_report_year, settlements.created_at AS settlements_created_at, settlements.updated_at AS settlements_updated_at, settlements.submitted_at AS settlements_submitted_at, settlements.completed_at AS settlements_completed_at, settlements.bank_id AS settlements_bank_id, settlements.disbursement_source AS settlements_disbursement_source, settlements.return_source AS settlements_return_source, settlements.admin_fee AS settlements_admin_fee, settlements.disbursed_amount AS settlements_disbursed_amount, settlements.returned_amount AS settlements_returned_amount, settlements.disbursement_comment AS settlements_disbursement_comment, settlements.return_description AS settlements_return_description, settlements.disbursement_evidence_path AS settlements_disbursement_evidence_path, settlements.disbursement_evidence_filename AS settlements_disbursement_evidence_filename, settlements.return_evidence_path AS settlements_return_evidence_path, settlements.return_evidence_filename AS settlements_return_evidence_filename, settlements.is_disbursement_approved AS settlements_is_disbursement_approved, settlements.is_return_approved AS settlements_is_return_approved, settlements.return_status AS settlements_return_status, settlements.return_notes AS settlements_return_notes, settlements.modified_t1 AS settlements_modified_t1, settlements.modified_t2 AS settlements_modified_t2, settlements.modified_t3 AS settlements_modified_t3, expenses_1.id AS expenses_1_id, expenses_1.settlement_id AS expenses_1_settlement_id, expenses_1.category_id AS expenses_1_category_id, expenses_1.description AS expenses_1_description, expenses_1.amount AS expenses_1_amount, expenses_1.date AS expenses_1_date, expenses_1.source AS expenses_1_source, expenses_1.revision_no AS expenses_1_revision_no, expenses_1.currency AS expenses_1_currency, expenses_1.currency_exchange AS expenses_1_currency_exchange, expenses_1.evidence_path AS expenses_1_evidence_path, expenses_1.evidence_filename AS expenses_1_evidence_filename, expenses_1.status AS expenses_1_status, expenses_1.notes AS expenses_1_notes, expenses_1.created_at AS expenses_1_created_at
FROM settlements LEFT OUTER JOIN expenses AS expenses_1 ON settlements.id = expenses_1.settlement_id
WHERE settlements.report_year = %(report_year_1)s ORDER BY settlements.created_at ASC, settlements.id ASC]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
192.168.68.51 - - [19/May/2026 14:57:35] "GET /api/expenses/categories HTTP/1.1" 200 -
192.168.68.51 - - [19/May/2026 14:57:35] "GET /api/advances?report_year=2031 HTTP/1.1" 500 -
192.168.68.51 - - [19/May/2026 14:57:35] "GET /api/advances?report_year=2031&mode=report HTTP/1.1" 500 -
Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
psycopg2.errors.UndefinedColumn: column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^


The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py", line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 188, in list_advances
    advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2704, in all
    return self._iter().all()  # type: ignore
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2857, in _iter
    result: Union[ScalarResult[_T], Result[_T]] = self.session.execute(
                                                  ^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2351, in execute
    return self._execute_internal(
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2249, in _execute_internal
    result: Result[Any] = compile_state_cls.orm_execute_statement(
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\context.py", line 306, in orm_execute_statement
    result = conn.execute(
             ^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1419, in execute
    return meth(
           ^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\sql\elements.py", line 527, in _execute_on_connection
    return connection._execute_clauseelement(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1641, in _execute_clauseelement
    ret = self._execute_context(
          ^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1846, in _execute_context
    return self._exec_single_context(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1986, in _exec_single_context
    self._handle_dbapi_exception(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 2363, in _handle_dbapi_exception
    raise sqlalchemy_exception.with_traceback(exc_info[2]) from e
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
sqlalchemy.exc.ProgrammingError: (psycopg2.errors.UndefinedColumn) column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^

[SQL: SELECT advances.id AS advances_id, advances.title AS advances_title, advances.description AS advances_description, advances.advance_type AS advances_advance_type, advances.user_id AS advances_user_id, advances.status AS advances_status, advances.notes AS advances_notes, advances.approved_revision_no AS advances_approved_revision_no, advances.active_revision_no AS advances_active_revision_no, advances.report_year AS advances_report_year, advances.created_at AS advances_created_at, advances.updated_at AS advances_updated_at, advances.approved_at AS advances_approved_at, advances.bank_id AS advances_bank_id, advances.disbursement_source AS advances_disbursement_source, advances.return_source AS advances_return_source, advances.admin_fee AS advances_admin_fee, advances.disbursed_amount AS advances_disbursed_amount, advances.returned_amount AS advances_returned_amount, advances.disbursement_comment AS advances_disbursement_comment, advances.return_description AS advances_return_description, advances.disbursement_evidence_path AS advances_disbursement_evidence_path, advances.disbursement_evidence_filename AS advances_disbursement_evidence_filename, advances.return_evidence_path AS advances_return_evidence_path, advances.return_evidence_filename AS advances_return_evidence_filename, advances.is_disbursement_approved AS advances_is_disbursement_approved, advances.is_return_approved AS advances_is_return_approved, advances.return_status AS advances_return_status, advances.return_notes AS advances_return_notes, advances.modified_t1 AS advances_modified_t1, advances.modified_t2 AS advances_modified_t2, advances.modified_t3 AS advances_modified_t3, advance_items_1.id AS advance_items_1_id, advance_items_1.advance_id AS advance_items_1_advance_id, advance_items_1.category_id AS advance_items_1_category_id, advance_items_1.description AS advance_items_1_description, advance_items_1.estimated_amount AS advance_items_1_estimated_amount, advance_items_1.revision_no AS advance_items_1_revision_no, advance_items_1.evidence_path AS advance_items_1_evidence_path, advance_items_1.evidence_filename AS advance_items_1_evidence_filename, advance_items_1.date AS advance_items_1_date, advance_items_1.source AS advance_items_1_source, advance_items_1.currency AS advance_items_1_currency, advance_items_1.currency_exchange AS advance_items_1_currency_exchange, advance_items_1.status AS advance_items_1_status, advance_items_1.notes AS advance_items_1_notes, advance_items_1.created_at AS advance_items_1_created_at, users_1.id AS users_1_id, users_1.username AS users_1_username, users_1.email AS users_1_email, users_1.password_hash AS users_1_password_hash, users_1.google_id AS users_1_google_id, users_1.reset_token AS users_1_reset_token, users_1.reset_token_expiry AS users_1_reset_token_expiry, users_1.full_name AS users_1_full_name, users_1.phone_number AS users_1_phone_number, users_1.workplace AS users_1_workplace, users_1.role AS users_1_role, users_1.profile_image AS users_1_profile_image, users_1.default_report_year AS users_1_default_report_year, users_1.last_login AS users_1_last_login, users_1.created_at AS users_1_created_at
FROM advances LEFT OUTER JOIN advance_items AS advance_items_1 ON advances.id = advance_items_1.advance_id LEFT OUTER JOIN users AS users_1 ON users_1.id = advances.user_id
WHERE advances.report_year = %(report_year_1)s ORDER BY advances.created_at ASC, advances.id ASC]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
psycopg2.errors.UndefinedColumn: column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^


The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py", line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 188, in list_advances
    advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2704, in all
    return self._iter().all()  # type: ignore
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2857, in _iter
    result: Union[ScalarResult[_T], Result[_T]] = self.session.execute(
                                                  ^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2351, in execute
    return self._execute_internal(
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2249, in _execute_internal
    result: Result[Any] = compile_state_cls.orm_execute_statement(
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\context.py", line 306, in orm_execute_statement
    result = conn.execute(
             ^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1419, in execute
    return meth(
           ^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\sql\elements.py", line 527, in _execute_on_connection
    return connection._execute_clauseelement(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1641, in _execute_clauseelement
    ret = self._execute_context(
          ^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1846, in _execute_context
    return self._exec_single_context(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1986, in _exec_single_context
    self._handle_dbapi_exception(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 2363, in _handle_dbapi_exception
    raise sqlalchemy_exception.with_traceback(exc_info[2]) from e
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
sqlalchemy.exc.ProgrammingError: (psycopg2.errors.UndefinedColumn) column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^

[SQL: SELECT advances.id AS advances_id, advances.title AS advances_title, advances.description AS advances_description, advances.advance_type AS advances_advance_type, advances.user_id AS advances_user_id, advances.status AS advances_status, advances.notes AS advances_notes, advances.approved_revision_no AS advances_approved_revision_no, advances.active_revision_no AS advances_active_revision_no, advances.report_year AS advances_report_year, advances.created_at AS advances_created_at, advances.updated_at AS advances_updated_at, advances.approved_at AS advances_approved_at, advances.bank_id AS advances_bank_id, advances.disbursement_source AS advances_disbursement_source, advances.return_source AS advances_return_source, advances.admin_fee AS advances_admin_fee, advances.disbursed_amount AS advances_disbursed_amount, advances.returned_amount AS advances_returned_amount, advances.disbursement_comment AS advances_disbursement_comment, advances.return_description AS advances_return_description, advances.disbursement_evidence_path AS advances_disbursement_evidence_path, advances.disbursement_evidence_filename AS advances_disbursement_evidence_filename, advances.return_evidence_path AS advances_return_evidence_path, advances.return_evidence_filename AS advances_return_evidence_filename, advances.is_disbursement_approved AS advances_is_disbursement_approved, advances.is_return_approved AS advances_is_return_approved, advances.return_status AS advances_return_status, advances.return_notes AS advances_return_notes, advances.modified_t1 AS advances_modified_t1, advances.modified_t2 AS advances_modified_t2, advances.modified_t3 AS advances_modified_t3, advance_items_1.id AS advance_items_1_id, advance_items_1.advance_id AS advance_items_1_advance_id, advance_items_1.category_id AS advance_items_1_category_id, advance_items_1.description AS advance_items_1_description, advance_items_1.estimated_amount AS advance_items_1_estimated_amount, advance_items_1.revision_no AS advance_items_1_revision_no, advance_items_1.evidence_path AS advance_items_1_evidence_path, advance_items_1.evidence_filename AS advance_items_1_evidence_filename, advance_items_1.date AS advance_items_1_date, advance_items_1.source AS advance_items_1_source, advance_items_1.currency AS advance_items_1_currency, advance_items_1.currency_exchange AS advance_items_1_currency_exchange, advance_items_1.status AS advance_items_1_status, advance_items_1.notes AS advance_items_1_notes, advance_items_1.created_at AS advance_items_1_created_at, users_1.id AS users_1_id, users_1.username AS users_1_username, users_1.email AS users_1_email, users_1.password_hash AS users_1_password_hash, users_1.google_id AS users_1_google_id, users_1.reset_token AS users_1_reset_token, users_1.reset_token_expiry AS users_1_reset_token_expiry, users_1.full_name AS users_1_full_name, users_1.phone_number AS users_1_phone_number, users_1.workplace AS users_1_workplace, users_1.role AS users_1_role, users_1.profile_image AS users_1_profile_image, users_1.default_report_year AS users_1_default_report_year, users_1.last_login AS users_1_last_login, users_1.created_at AS users_1_created_at
FROM advances LEFT OUTER JOIN advance_items AS advance_items_1 ON advances.id = advance_items_1.advance_id LEFT OUTER JOIN users AS users_1 ON users_1.id = advances.user_id
WHERE advances.report_year = %(report_year_1)s ORDER BY advances.created_at ASC, advances.id ASC]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
192.168.68.51 - - [19/May/2026 14:57:35] "GET /api/advances?report_year=2031 HTTP/1.1" 500 -
Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
psycopg2.errors.UndefinedColumn: column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^


The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py", line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py", line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py", line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 188, in list_advances
    advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2704, in all
    return self._iter().all()  # type: ignore
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2857, in _iter
    result: Union[ScalarResult[_T], Result[_T]] = self.session.execute(
                                                  ^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2351, in execute
    return self._execute_internal(
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2249, in _execute_internal
    result: Result[Any] = compile_state_cls.orm_execute_statement(
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\context.py", line 306, in orm_execute_statement
    result = conn.execute(
             ^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1419, in execute
    return meth(
           ^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\sql\elements.py", line 527, in _execute_on_connection
    return connection._execute_clauseelement(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1641, in _execute_clauseelement
    ret = self._execute_context(
          ^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1846, in _execute_context
    return self._exec_single_context(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1986, in _exec_single_context
    self._handle_dbapi_exception(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 2363, in _handle_dbapi_exception
    raise sqlalchemy_exception.with_traceback(exc_info[2]) from e
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
sqlalchemy.exc.ProgrammingError: (psycopg2.errors.UndefinedColumn) column advances.disbursement_comment does not exist
LINE 1: ...nces.returned_amount AS advances_returned_amount, advances.d...
                                                             ^

[SQL: SELECT advances.id AS advances_id, advances.title AS advances_title, advances.description AS advances_description, advances.advance_type AS advances_advance_type, advances.user_id AS advances_user_id, advances.status AS advances_status, advances.notes AS advances_notes, advances.approved_revision_no AS advances_approved_revision_no, advances.active_revision_no AS advances_active_revision_no, advances.report_year AS advances_report_year, advances.created_at AS advances_created_at, advances.updated_at AS advances_updated_at, advances.approved_at AS advances_approved_at, advances.bank_id AS advances_bank_id, advances.disbursement_source AS advances_disbursement_source, advances.return_source AS advances_return_source, advances.admin_fee AS advances_admin_fee, advances.disbursed_amount AS advances_disbursed_amount, advances.returned_amount AS advances_returned_amount, advances.disbursement_comment AS advances_disbursement_comment, advances.return_description AS advances_return_description, advances.disbursement_evidence_path AS advances_disbursement_evidence_path, advances.disbursement_evidence_filename AS advances_disbursement_evidence_filename, advances.return_evidence_path AS advances_return_evidence_path, advances.return_evidence_filename AS advances_return_evidence_filename, advances.is_disbursement_approved AS advances_is_disbursement_approved, advances.is_return_approved AS advances_is_return_approved, advances.return_status AS advances_return_status, advances.return_notes AS advances_return_notes, advances.modified_t1 AS advances_modified_t1, advances.modified_t2 AS advances_modified_t2, advances.modified_t3 AS advances_modified_t3, advance_items_1.id AS advance_items_1_id, advance_items_1.advance_id AS advance_items_1_advance_id, advance_items_1.category_id AS advance_items_1_category_id, advance_items_1.description AS advance_items_1_description, advance_items_1.estimated_amount AS advance_items_1_estimated_amount, advance_items_1.revision_no AS advance_items_1_revision_no, advance_items_1.evidence_path AS advance_items_1_evidence_path, advance_items_1.evidence_filename AS advance_items_1_evidence_filename, advance_items_1.date AS advance_items_1_date, advance_items_1.source AS advance_items_1_source, advance_items_1.currency AS advance_items_1_currency, advance_items_1.currency_exchange AS advance_items_1_currency_exchange, advance_items_1.status AS advance_items_1_status, advance_items_1.notes AS advance_items_1_notes, advance_items_1.created_at AS advance_items_1_created_at, users_1.id AS users_1_id, users_1.username AS users_1_username, users_1.email AS users_1_email, users_1.password_hash AS users_1_password_hash, users_1.google_id AS users_1_google_id, users_1.reset_token AS users_1_reset_token, users_1.reset_token_expiry AS users_1_reset_token_expiry, users_1.full_name AS users_1_full_name, users_1.phone_number AS users_1_phone_number, users_1.workplace AS users_1_workplace, users_1.role AS users_1_role, users_1.profile_image AS users_1_profile_image, users_1.default_report_year AS users_1_default_report_year, users_1.last_login AS users_1_last_login, users_1.created_at AS users_1_created_at
FROM advances LEFT OUTER JOIN advance_items AS advance_items_1 ON advances.id = advance_items_1.advance_id LEFT OUTER JOIN users AS users_1 ON users_1.id = advances.user_id
WHERE advances.report_year = %(report_year_1)s ORDER BY advances.created_at ASC, advances.id ASC]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
[SUMMARY_API] User=manager1, role=manager
192.168.68.51 - - [19/May/2026 14:57:36] "GET /api/reports/summary?year=2031 HTTP/1.1" 200 -



# dan ini juga



(venv) D:\Aplikasi\EWIApps\backend>python app.py
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.68.51:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 539-689-693
192.168.68.51 - - [19/May/2026 14:59:09] "GET /api/expenses/categories HTTP/1.1" 200 -
192.168.68.51 - - [19/May/2026 14:59:09] "GET /api/expenses/categories HTTP/1.1" 200 -

[ANNUAL_REPORT_DEBUG] Building payload for year=2031 mode=report
Error generating annual report: (psycopg2.errors.UndefinedColumn) column settlements.disbursement_comment does not exist
LINE 2: ...s.returned_amount AS settlements_returned_amount, settlement...
                                                             ^

[SQL: SELECT count(*) AS count_1
FROM (SELECT settlements.id AS settlements_id, settlements.title AS settlements_title, settlements.description AS settlements_description, settlements.user_id AS settlements_user_id, settlements.settlement_type AS settlements_settlement_type, settlements.status AS settlements_status, settlements.report_year AS settlements_report_year, settlements.created_at AS settlements_created_at, settlements.updated_at AS settlements_updated_at, settlements.submitted_at AS settlements_submitted_at, settlements.completed_at AS settlements_completed_at, settlements.bank_id AS settlements_bank_id, settlements.disbursement_source AS settlements_disbursement_source, settlements.return_source AS settlements_return_source, settlements.admin_fee AS settlements_admin_fee, settlements.disbursed_amount AS settlements_disbursed_amount, settlements.returned_amount AS settlements_returned_amount, settlements.disbursement_comment AS settlements_disbursement_comment, settlements.return_description AS settlements_return_description, settlements.disbursement_evidence_path AS settlements_disbursement_evidence_path, settlements.disbursement_evidence_filename AS settlements_disbursement_evidence_filename, settlements.return_evidence_path AS settlements_return_evidence_path, settlements.return_evidence_filename AS settlements_return_evidence_filename, settlements.is_disbursement_approved AS settlements_is_disbursement_approved, settlements.is_return_approved AS settlements_is_return_approved, settlements.return_status AS settlements_return_status, settlements.return_notes AS settlements_return_notes, settlements.modified_t1 AS settlements_modified_t1, settlements.modified_t2 AS settlements_modified_t2, settlements.modified_t3 AS settlements_modified_t3
FROM settlements
WHERE settlements.report_year = %(report_year_1)s) AS anon_1]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
Traceback (most recent call last):
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
psycopg2.errors.UndefinedColumn: column settlements.disbursement_comment does not exist
LINE 2: ...s.returned_amount AS settlements_returned_amount, settlement...
                                                             ^


The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "D:\Aplikasi\EWIApps\backend\routes\reports\annual.py", line 4316, in get_annual_report
    payload = _build_annual_payload_from_db(
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\reports\annual.py", line 634, in _build_annual_payload_from_db
    raw_set_count = Settlement.query.filter(Settlement.report_year == year).count()
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 3146, in count
    self._legacy_from_self(col).enable_eagerloads(False).scalar()
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2835, in scalar
    ret = self.one()
          ^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2808, in one
    return self._iter().one()  # type: ignore
           ^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\query.py", line 2857, in _iter
    result: Union[ScalarResult[_T], Result[_T]] = self.session.execute(
                                                  ^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2351, in execute
    return self._execute_internal(
           ^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\session.py", line 2249, in _execute_internal
    result: Result[Any] = compile_state_cls.orm_execute_statement(
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\orm\context.py", line 306, in orm_execute_statement
    result = conn.execute(
             ^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1419, in execute
    return meth(
           ^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\sql\elements.py", line 527, in _execute_on_connection
    return connection._execute_clauseelement(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1641, in _execute_clauseelement
    ret = self._execute_context(
          ^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1846, in _execute_context
    return self._exec_single_context(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1986, in _exec_single_context
    self._handle_dbapi_exception(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 2363, in _handle_dbapi_exception
    raise sqlalchemy_exception.with_traceback(exc_info[2]) from e
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\base.py", line 1967, in _exec_single_context
    self.dialect.do_execute(
  File "D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\sqlalchemy\engine\default.py", line 952, in do_execute
    cursor.execute(statement, parameters)
sqlalchemy.exc.ProgrammingError: (psycopg2.errors.UndefinedColumn) column settlements.disbursement_comment does not exist
LINE 2: ...s.returned_amount AS settlements_returned_amount, settlement...
                                                             ^

[SQL: SELECT count(*) AS count_1
FROM (SELECT settlements.id AS settlements_id, settlements.title AS settlements_title, settlements.description AS settlements_description, settlements.user_id AS settlements_user_id, settlements.settlement_type AS settlements_settlement_type, settlements.status AS settlements_status, settlements.report_year AS settlements_report_year, settlements.created_at AS settlements_created_at, settlements.updated_at AS settlements_updated_at, settlements.submitted_at AS settlements_submitted_at, settlements.completed_at AS settlements_completed_at, settlements.bank_id AS settlements_bank_id, settlements.disbursement_source AS settlements_disbursement_source, settlements.return_source AS settlements_return_source, settlements.admin_fee AS settlements_admin_fee, settlements.disbursed_amount AS settlements_disbursed_amount, settlements.returned_amount AS settlements_returned_amount, settlements.disbursement_comment AS settlements_disbursement_comment, settlements.return_description AS settlements_return_description, settlements.disbursement_evidence_path AS settlements_disbursement_evidence_path, settlements.disbursement_evidence_filename AS settlements_disbursement_evidence_filename, settlements.return_evidence_path AS settlements_return_evidence_path, settlements.return_evidence_filename AS settlements_return_evidence_filename, settlements.is_disbursement_approved AS settlements_is_disbursement_approved, settlements.is_return_approved AS settlements_is_return_approved, settlements.return_status AS settlements_return_status, settlements.return_notes AS settlements_return_notes, settlements.modified_t1 AS settlements_modified_t1, settlements.modified_t2 AS settlements_modified_t2, settlements.modified_t3 AS settlements_modified_t3
FROM settlements
WHERE settlements.report_year = %(report_year_1)s) AS anon_1]
[parameters: {'report_year_1': 2031}]
(Background on this error at: https://sqlalche.me/e/20/f405)
192.168.68.51 - - [19/May/2026 14:59:09] "GET /api/reports/annual?year=2031&mode=report HTTP/1.1" 500 -

