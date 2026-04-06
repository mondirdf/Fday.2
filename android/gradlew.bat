@ECHO OFF
where gradle >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
  ECHO Gradle is not installed. Please install Gradle or regenerate wrapper with Flutter.
  EXIT /B 1
)
CALL gradle %*
