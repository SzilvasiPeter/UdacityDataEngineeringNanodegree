CREATE master KEY encryption BY password = 'MyTest!Mast3rP4ss';

OPEN master KEY decryption BY password = 'MyTest!Mast3rP4ss';
CLOSE master KEY
GO