D:\Aplikasi\EWIApps\frontend>flutter run
Connected devices:
Windows (desktop) • windows • windows-x64 • Microsoft Windows [Version
10.0.26200.8524]
Chrome (web) • chrome • web-javascript • Google Chrome 148.0.7778.181
Edge (web) • edge • web-javascript • Microsoft Edge 148.0.3967.96
[1]: Windows (windows)
[2]: Chrome (chrome)
[3]: Edge (edge)
Please choose one (or "q" to quit): 1
Launching lib\main.dart on Windows in debug mode...
Building Windows application... 8.4s
√ Built build\windows\x64\runner\Debug\expense_app.exe
Syncing files to device Windows... 122ms

Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on Windows is available at:
http://127.0.0.1:51159/4imAnZ7gAgQ=/
The Flutter DevTools debugger and profiler on Windows is available at:
http://127.0.0.1:51159/4imAnZ7gAgQ=/devtools/?uri=ws://127.0.0.1:51159/4imAn
Z7gAgQ=/ws
Attempting login to: http://192.168.68.53:5000/api/auth/login
[DEBUG] loaded sort mode from SharedPreferences: tanggal
[DEBUG] loaded sort mode from SharedPreferences: tanggal
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.500733
Endpoint: GET http://192.168.68.53:5000/api/settlements?report_year=2030&mode=report
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Settlement&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Settlement&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338084763776">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338084763920">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338084764064">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084764208">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338084764352">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338084764496">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084764640">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338084764784">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338084764928">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338084765072">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\settlements.py"</cite>,
      line <em class="line">236</em>,
      in <code class="function">list_settlements</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>f&#34;[SETTLEMENT_API]   - ID={s.id}, title={s.title}, status={s.status}, created_at={s.created_at}, year={s.created_at.year if s.created_at else &#39;?&#39;}&#34;</pre>
<pre class="line before"><span class="ws">        </span>)</pre>
<pre class="line before"><span class="ws">    </span>if len(ordered) &gt; 10:</pre>
<pre class="line before"><span class="ws">        </span>print(f&#34;[SETTLEMENT_API]   ... and {len(ordered) - 10} more&#34;)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;settlements&#34;: [s.to_dict() for s in ordered]}), 200
<span class="ws">    </span>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@settlements_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_settlement():</pre></div>
</div>

<li><div class="frame" id="frame-2338087420400">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\settlements.py"</cite>,
      line <em class="line">236</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>f&#34;[SETTLEMENT_API]   - ID={s.id}, title={s.title}, status={s.status}, created_at={s.created_at}, year={s.created_at.year if s.created_at else &#39;?&#39;}&#34;</pre>
<pre class="line before"><span class="ws">        </span>)</pre>
<pre class="line before"><span class="ws">    </span>if len(ordered) &gt; 10:</pre>
<pre class="line before"><span class="ws">        </span>print(f&#34;[SETTLEMENT_API]   ... and {len(ordered) - 10} more&#34;)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;settlements&#34;: [s.to_dict() for s in ordered]}), 200
<span class="ws">    </span>                                ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@settlements_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_settlement():</pre></div>
</div>

<li><div class="frame" id="frame-2338087420544">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">740</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">        </span>}</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Settlement&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\settlements.py&#34;, line 236, in list_settlements
    return jsonify({&#34;settlements&#34;: [s.to_dict() for s in ordered]}), 200
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\settlements.py&#34;, line 236, in &lt;listcomp&gt;
    return jsonify({&#34;settlements&#34;: [s.to_dict() for s in ordered]}), 200
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 740, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Settlement&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\settlements.py", line 236, in list_settlements
    return jsonify({"settlements": [s.to_dict() for s in ordered]}), 200
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\settlements.py", line 236, in <listcomp>
    return jsonify({"settlements": [s.to_dict() for s in ordered]}), 200
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 740, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Settlement' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.548617
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338086649088">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338086635840">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338086645200">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086645344">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338086645488">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338086645632">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086645776">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338086641312">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338086641456">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338086641600">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086641744">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086641888">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.549619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338082368256">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338084752256">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338084752400">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084750240">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338084750528">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338084750672">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084762768">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338084762912">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338084763056">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338084752832">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338085323392">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338085323248">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.549619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338086935936">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338086937520">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338086937664">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086937808">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338086937952">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338086938096">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086938240">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338086938384">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338086938528">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338086938672">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086938816">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086938960">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.550619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338086642032">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338086642176">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338086642320">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086642464">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338086642608">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338086642752">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086642896">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338086643040">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338086643184">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338086643328">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086633968">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086640160">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.550619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030&mode=report
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338084753264">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338078510816">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338078316656">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084749376">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338084749520">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338084749664">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084749808">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338084749952">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338084750096">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338085324112">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086634112">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086634400">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.551619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338078518448">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338082358896">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338084753552">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084761904">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338084761760">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338084761616">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084761472">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338084761184">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338084755856">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338085324256">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086647072">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086647216">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.552619
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338086640448">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338086640304">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338086640592">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086640736">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338086640880">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338086641024">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086641168">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338086636416">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338086643616">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338086643760">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086643904">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086644048">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.655958
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338086644768">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338086931040">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338086930896">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086930752">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338086930608">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338086941264">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338086941408">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338086941552">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338086941696">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338086941840">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086941984">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338086942128">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
</div>
</ul>
  <blockquote>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</blockquote>
</div>

<div class="plain">
    <p>
      This is the Copy/Paste friendly version of the traceback.
    </p>
    <textarea cols="50" rows="10" name="code" readonly>Traceback (most recent call last):
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1536, in __call__
    return self.wsgi_app(environ, start_response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1514, in wsgi_app
    response = self.handle_exception(e)
               ^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 1511, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 919, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py&#34;, line 176, in wrapped_function
    return cors_after_request(app.make_response(f(*args, **kwargs)))
                                                ^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 917, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py&#34;, line 902, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py&#34;, line 170, in decorator
    return current_app.ensure_sync(fn)(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in list_advances
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\routes\advances.py&#34;, line 247, in &lt;listcomp&gt;
    return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File &#34;D:\Aplikasi\EWIApps\backend\models.py&#34;, line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</textarea>
</div>
<div class="explanation">
  The debugger caught an exception in your WSGI application.  You can now
  look at the traceback which led to the error.  <span class="nojavascript">
  If you enable JavaScript you can also use additional features such as code
  execution (if the evalex feature is enabled), automatic pasting of the
  exceptions and much more.</span>
</div>
      <div class="footer">
        Brought to you by <strong class="arthur">DON'T PANIC</strong>, your
        friendly Werkzeug powered traceback interpreter.
      </div>
    </div>

    <div class="pin-prompt">
      <div class="inner">
        <h3>Console Locked</h3>
        <p>
          The console is locked and needs to be unlocked by entering the PIN.
          You can find the PIN printed out on the standard output of your
          shell that runs the server.
        <form>
          <p>PIN:
            <input type=text name=pin size=14>
            <input type=submit name=btn value="Confirm Pin">
        </form>
      </div>
    </div>

  </body>
</html>

<!--

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
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in list_advances
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\routes\advances.py", line 247, in <listcomp>
    return jsonify({"advances": [a.to_dict() for a in advances]}), 200
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\Aplikasi\EWIApps\backend\models.py", line 492, in to_dict
    if self.expected_completion_at
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'Advance' object has no attribute 'expected_completion_at'


-->

==================================================\n
\n==================================================
[BACKEND ERROR] Detected at 2026-06-02 14:39:04.655958
Endpoint: GET http://192.168.68.53:5000/api/advances?report_year=2030
Status Code: 500
Error Body: <!doctype html>

<html lang=en>
  <head>
    <title>AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
 // Werkzeug Debugger</title>
    <link rel="stylesheet" href="?__debugger__=yes&amp;cmd=resource&amp;f=style.css">
    <link rel="shortcut icon"
        href="?__debugger__=yes&amp;cmd=resource&amp;f=console.png">
    <script src="?__debugger__=yes&amp;cmd=resource&amp;f=debugger.js"></script>
    <script>
      var CONSOLE_MODE = false,
          EVALEX = false,
          EVALEX_TRUSTED = false,
          SECRET = "gUs2KdAdJi3ncaDK5MN8";
    </script>
  </head>
  <body style="background-color: #fff">
    <div class="debugger">
<h1>AttributeError</h1>
<div class="detail">
  <p class="errormsg">AttributeError: &#39;Advance&#39; object has no attribute &#39;expected_completion_at&#39;
</p>
</div>
<h2 class="traceback">Traceback <em>(most recent call last)</em></h2>
<div class="traceback">
  <h3></h3>
  <ul><li><div class="frame" id="frame-2338084753408">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1536</em>,
      in <code class="function">__call__</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">    </span>) -&gt; cabc.Iterable[bytes]:</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;The WSGI server calls the Flask application object as the</pre>
<pre class="line before"><span class="ws">        </span>WSGI application. This calls :meth:`wsgi_app`, which can be</pre>
<pre class="line before"><span class="ws">        </span>wrapped to apply middleware.</pre>
<pre class="line before"><span class="ws">        </span>&#34;&#34;&#34;</pre>
<pre class="line current"><span class="ws">        </span>return self.wsgi_app(environ, start_response)
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre></div>
</div>

<li><div class="frame" id="frame-2338084753696">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1514</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line before"><span class="ws">                </span>response = self.full_dispatch_request()</pre>
<pre class="line before"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line before"><span class="ws">                </span>error = e</pre>
<pre class="line current"><span class="ws">                </span>response = self.handle_exception(e)
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre>
<pre class="line after"><span class="ws">                </span>raise</pre>
<pre class="line after"><span class="ws">            </span>return response(environ, start_response)</pre>
<pre class="line after"><span class="ws">        </span>finally:</pre></div>
</div>

<li><div class="frame" id="frame-2338084753840">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084756000">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">1511</em>,
      in <code class="function">wsgi_app</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>ctx = self.request_context(environ)</pre>
<pre class="line before"><span class="ws">        </span>error: BaseException | None = None</pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>try:</pre>
<pre class="line before"><span class="ws">                </span>ctx.push()</pre>
<pre class="line current"><span class="ws">                </span>response = self.full_dispatch_request()
<span class="ws">                </span>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">                </span>error = e</pre>
<pre class="line after"><span class="ws">                </span>response = self.handle_exception(e)</pre>
<pre class="line after"><span class="ws">            </span>except:  # noqa: B001</pre>
<pre class="line after"><span class="ws">                </span>error = sys.exc_info()[1]</pre></div>
</div>

<li><div class="frame" id="frame-2338084756144">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">919</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line before"><span class="ws">                </span>rv = self.dispatch_request()</pre>
<pre class="line before"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line current"><span class="ws">            </span>rv = self.handle_user_exception(e)
<span class="ws">            </span>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre>
<pre class="line after"><span class="ws">        </span>self,</pre>
<pre class="line after"><span class="ws">        </span>rv: ft.ResponseReturnValue | HTTPException,</pre></div>
</div>

<li><div class="frame" id="frame-2338084756288">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_cors\extension.py"</cite>,
      line <em class="line">176</em>,
      in <code class="function">wrapped_function</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span># These error handlers will still respect the behavior of the route</pre>
<pre class="line before"><span class="ws">        </span>if options.get(&#34;intercept_exceptions&#34;, True):</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">            </span>def _after_request_decorator(f):</pre>
<pre class="line before"><span class="ws">                </span>def wrapped_function(*args, **kwargs):</pre>
<pre class="line current"><span class="ws">                    </span>return cors_after_request(app.make_response(f(*args, **kwargs)))
<span class="ws">                    </span>                                            ^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">                </span>return wrapped_function</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">            </span>if hasattr(app, &#34;handle_exception&#34;):</pre>
<pre class="line after"><span class="ws">                </span>app.handle_exception = _after_request_decorator(app.handle_exception)</pre></div>
</div>

<li><div class="frame" id="frame-2338084756432">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">917</em>,
      in <code class="function">full_dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>try:</pre>
<pre class="line before"><span class="ws">            </span>request_started.send(self, _async_wrapper=self.ensure_sync)</pre>
<pre class="line before"><span class="ws">            </span>rv = self.preprocess_request()</pre>
<pre class="line before"><span class="ws">            </span>if rv is None:</pre>
<pre class="line current"><span class="ws">                </span>rv = self.dispatch_request()
<span class="ws">                </span>     ^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">        </span>except Exception as e:</pre>
<pre class="line after"><span class="ws">            </span>rv = self.handle_user_exception(e)</pre>
<pre class="line after"><span class="ws">        </span>return self.finalize_request(rv)</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def finalize_request(</pre></div>
</div>

<li><div class="frame" id="frame-2338084756576">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask\app.py"</cite>,
      line <em class="line">902</em>,
      in <code class="function">dispatch_request</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">            </span>and req.method == &#34;OPTIONS&#34;</pre>
<pre class="line before"><span class="ws">        </span>):</pre>
<pre class="line before"><span class="ws">            </span>return self.make_default_options_response()</pre>
<pre class="line before"><span class="ws">        </span># otherwise dispatch to the handler for that endpoint</pre>
<pre class="line before"><span class="ws">        </span>view_args: dict[str, t.Any] = req.view_args  # type: ignore[assignment]</pre>
<pre class="line current"><span class="ws">        </span>return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)  # type: ignore[no-any-return]
<span class="ws">        </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>def full_dispatch_request(self) -&gt; Response:</pre>
<pre class="line after"><span class="ws">        </span>&#34;&#34;&#34;Dispatches the request and on top of that performs request</pre>
<pre class="line after"><span class="ws">        </span>pre and postprocessing as well as HTTP exception catching and</pre>
<pre class="line after"><span class="ws">        </span>error handling.</pre></div>
</div>

<li><div class="frame" id="frame-2338084756720">
  <h4>File <cite class="filename">"D:\2. Organize\1. Projects\MiniProjectKPI_EWI\backend\venv\Lib\site-packages\flask_jwt_extended\view_decorators.py"</cite>,
      line <em class="line">170</em>,
      in <code class="function">decorator</code></h4>
  <div class="source library"><pre class="line before"><span class="ws">        </span>@wraps(fn)</pre>
<pre class="line before"><span class="ws">        </span>def decorator(*args, **kwargs):</pre>
<pre class="line before"><span class="ws">            </span>verify_jwt_in_request(</pre>
<pre class="line before"><span class="ws">                </span>optional, fresh, refresh, locations, verify_type, skip_revocation_check</pre>
<pre class="line before"><span class="ws">            </span>)</pre>
<pre class="line current"><span class="ws">            </span>return current_app.ensure_sync(fn)(*args, **kwargs)
<span class="ws">            </span>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">        </span>return decorator</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws">    </span>return wrapper</pre>
<pre class="line after"><span class="ws"></span> </pre></div>
</div>

<li><div class="frame" id="frame-2338084756864">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">list_advances</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338084763488">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\routes\advances.py"</cite>,
      line <em class="line">247</em>,
      in <code class="function">&lt;listcomp&gt;</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">        </span>query = query.filter(db.or_(*or_conditions))</pre>
<pre class="line before"><span class="ws"></span> </pre>
<pre class="line before"><span class="ws">    </span>advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()</pre>
<pre class="line current"><span class="ws">    </span>return jsonify({&#34;advances&#34;: [a.to_dict() for a in advances]}), 200
<span class="ws">    </span>                             ^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span> </pre>
<pre class="line after"><span class="ws"></span>@advances_bp.route(&#34;&#34;, methods=[&#34;POST&#34;])</pre>
<pre class="line after"><span class="ws"></span>@jwt_required()</pre>
<pre class="line after"><span class="ws"></span>def create_advance():</pre></div>
</div>

<li><div class="frame" id="frame-2338084763632">
  <h4>File <cite class="filename">"D:\Aplikasi\EWIApps\backend\models.py"</cite>,
      line <em class="line">492</em>,
      in <code class="function">to_dict</code></h4>
  <div class="source "><pre class="line before"><span class="ws">            </span>&#34;modified_t1&#34;: self.modified_t1 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t2&#34;: self.modified_t2 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;modified_t3&#34;: self.modified_t3 or False,</pre>
<pre class="line before"><span class="ws">            </span>&#34;current_stage&#34;: self.current_stage or &#34;draft&#34;,</pre>
<pre class="line before"><span class="ws">            </span>&#34;expected_completion_at&#34;: self.expected_completion_at.isoformat()</pre>
<pre class="line current"><span class="ws">            </span>if self.expected_completion_at
<span class="ws">            </span>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^</pre>
<pre class="line after"><span class="ws">            </span>else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_id&#34;: self.bank_id,</pre>
<pre class="line after"><span class="ws">            </span>&#34;bank_name&#34;: self.bank.name if self.bank else None,</pre>
<pre class="line after"><span class="ws">            </span>&#34;policy_warnings&#34;: policy_warnings,</pre>
<pre class="line after"><span class="ws">            </span>&#34;revision_summaries&#34;: revision_summaries,</pre></div>
Application finished.
