# APQ - MySQL

This is the MySQL impementation for the APQ database bindings.

The [main APQ](https://github.com/ada-apq/apq) repository
contains more useful documentation, but as a simple example:


```ada
with APQ;                       use APQ;
with APQ.MySQL.Client; 		use APQ.MySQL.Client;

procedure list_users is
        C: Connection_Type;
begin
	Set_Host_Name( C, "localhost" );
	Set_User_Password( C, "root", "some pwd for root here" );
	
	Set_DB_Name( C, "apq_test" );
	
	Set_Case( C, Upper_Case );
	
	Connect( C );

	Open_DB_Trace( C, "trace.log", Trace_Full );


	-- now you run quries
	declare
		Q: Root_Query_Type'Class := New_Query( C );


		function Value( S: in String ) return String is
		begin
			return Value( Q, Column_Index( Q, S ) );
		end Value;
	begin
		Prepare( Q, "SELECT * FROM USERS" );

		Execute( Q, C );

		loop
			begin
				Fetch( Q );
			exception
				when No_Tuple => exit;
			end;

			Put( "Name: " & Value( "Name" ) );
			Put( "   |   " );
			Put( "Birth date: " & Value( "Birth" ) );

			New_Line;
		end loop;
	end Query_Results;
end list_users;
```

