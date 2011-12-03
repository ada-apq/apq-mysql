------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--                              A P Q - MYSQL  				    --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    --
--         Copyright (C) 2007-2011, KOW Framework Project                   --
--                                                                          --
--                                                                          --
-- APQ is free software;  you can  redistribute it  and/or modify it under  --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  APQ is distributed in the hope that it will be useful, but WITH-  --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with APQ;  see file COPYING.  If not, write  --
-- to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, --
-- MA 02111-1307, USA.                                                      --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- This is the package that actually has the MySQL driver implementation    --
------------------------------------------------------------------------------

with System;
with Interfaces;
with Ada.Text_IO.C_Streams;
with Ada.Finalization;
with Ada.Streams.Stream_IO;
with Ada.Calendar;
with Ada.Strings.Bounded;
with Ada.Strings.Unbounded;
with Interfaces.C_Streams;
with ada.Strings.Fixed;
with Interfaces.C;

package APQ.MySQL.Client is

	package Str renames Ada.Streams;
	package CStr renames Interfaces.C_Streams;

	-----------------------
	-- CLIENT DATA TYPES --
	-----------------------
	type Connection_Type is new APQ.Root_Connection_Type with private;

	function Query_Factory( C: in Connection_Type ) return Root_Query_Type'Class;

	type Query_Type is new APQ.Root_Query_Type with private;

	function SQL_Code(Query : Query_Type) return SQL_Code_Type;


	---------------------------
	-- DATABASE CONNECTION : --
	---------------------------
	function Engine_Of(C : Connection_Type) return Database_Type;
	function New_Query(C : Connection_Type) return Root_Query_Type'Class;

	procedure Set_DB_Name(C : in out Connection_Type; DB_Name : String);

	function Port(C : Connection_Type) return Integer;
	function Port(C : Connection_Type) return String;

	procedure Set_Instance(C : in out Connection_Type; Instance : String);

   procedure Set_Options(C : in out Connection_Type; Options : String);
   function Options (C : Connection_Type) return String;
   -----
   function quote_string( qkv : string ) return ada.Strings.Unbounded.Unbounded_String;
   function quote_string( qkv : string ) return String;
   procedure grow_key( C : in out Connection_Type); --

   function  cache_key_nameval_uptodate( C : Connection_Type) return boolean;--
   pragma inline(cache_key_nameval_uptodate);
   -- if force = true, re-create it even if already uptodate;
   -- if force = false,(automatic,normal daily use) re-create only if necessary/not-uptodate
   procedure cache_key_nameval_create( C : in out Connection_Type; force : boolean := false);

   function get_keyname_default_case( C : Connection_Type) return SQL_Case_Type;--
   function get_keyval_default_case( C : Connection_Type) return SQL_Case_Type;--
   procedure set_keyname_default_case( C : in out Connection_Type; sqlcase: SQL_Case_Type);--
   procedure set_keyval_default_case( C : in out Connection_Type; sqlcase: SQL_Case_Type);--
   pragma inline(get_keyname_default_case);
   pragma inline(get_keyval_default_case);
   pragma inline(set_keyname_default_case);
   pragma inline(set_keyval_default_case);

   -- add keyword and his respective value for the connection string.
   -- if clear = false, just append keyword and value to list of keywords and values
   -- if clear = true, remove all values in list before add keyword and value to list
   -- see (e.g.)http://dev.mysql.com/doc/refman/5.1/en/mysql-options.html
   -- or yet more uptodate url,for example of keyname(s) e theirs possible keyvals :-)
   --
   -- if in the list of keywords have keywords equals the value used is the last value in list.
   -- remember to include the libs was needed
   procedure add_key_nameval( C : in out Connection_Type;
			     kname,kval : string := ""; -- the standard way
			     kval_type : apq.mysql.Argument_Type := ARG_CHAR_PTR ; -- dont ignore it ! :-)
                             knamecasele, kvalcasele : boolean := true;
			     clear : boolean := false);

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.ssl_type ; -- to reduce typing errors
			     kval : string ;
			     kval_type : apq.mysql.Argument_Type := ARG_CHAR_PTR ;
			     -- kval_type is ignored here :-). it is always arg_char_ptr :-)
                             knamecasele, kvalcasele : boolean := true;
			     clear : boolean := false);

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.Option_type ; -- to reduce typing errors
			     kval : string ;
			     kval_type : apq.mysql.Argument_Type := ARG_CHAR_PTR ; -- dont ignore it ! :-)
                             knamecasele, kvalcasele : boolean := true;
			     clear : boolean := false);

   procedure clear_all_key_nameval(C : in out Connection_Type; add_more_this_alloc : natural := 0);

   function verifica_conninfo_cache( C : Connection_Type) return string;
   -- only already cached value(s) even if not update. if you want show all values
   -- even if not uptodate before a connect(), you can use cache_key_nameval_create() :-)

    	procedure Connect(C : in out Connection_Type; Check_Connection : Boolean := True);

       	procedure Connect(C : in out Connection_Type;
			  Same_As : Root_Connection_Type'Class);

   	procedure Disconnect(C : in out Connection_Type);

	function Is_Connected(C : Connection_Type) return Boolean;
	procedure Reset(C : in out Connection_Type);
   function Error_Message(C : Connection_Type) return String;

	-- Open trace output file
	procedure Open_DB_Trace(C : in out Connection_Type;
		Filename : String; Mode : Trace_Mode_Type := Trace_APQ);


	-- Close trace output file
	procedure Close_DB_Trace(C : in out Connection_Type);

	-- Enable/Disable tracing
	procedure Set_Trace(C : in out Connection_Type;
		Trace_On : Boolean := True);

	-- Test trace enabled/disabled
	function Is_Trace(C : Connection_Type) return Boolean;

	function In_Abort_State(C : Connection_Type) return Boolean;

	---------------------
	-- SQL QUERY API : --
	---------------------
	procedure Clear(Q : in out Query_Type);
	procedure Append_Quoted(Q : in out Query_Type;
				Connection : Root_Connection_Type'Class;
				SQL : String; After : String := "");
	procedure Set_Fetch_Mode(Q : in out Query_Type; Mode : Fetch_Mode_Type);

	procedure Execute(Query : in out Query_Type;
			  Connection : in out Root_Connection_Type'Class);
	procedure Execute_Checked(Query : in out Query_Type;
				  Connection : in out Root_Connection_Type'Class;
				  Msg : String := "");

	procedure Begin_Work(   Query : in out Query_Type;
				Connection : in out Root_Connection_Type'Class);
	procedure Commit_Work(  Query : in out Query_Type;
				Connection : in out Root_Connection_Type'Class);
	procedure Rollback_Work(Query : in out Query_Type;
				Connection : in out Root_Connection_Type'Class);

	procedure Rewind(Q : in out Query_Type);
	procedure Fetch(Q : in out Query_Type);
	procedure Fetch(Q : in out Query_Type; TX : Tuple_Index_Type);

	-- Do not use with Sequential_Fetch mode!
        function End_of_Query(Q : Query_Type) return Boolean;

	function Tuple(Q : Query_Type) return Tuple_Index_Type;
	function Tuples(Q : Query_Type) return Tuple_Count_Type;

	function Columns(Q : Query_Type) return Natural;
	function Column_Name(Q : Query_Type; CX : Column_Index_Type)
		return String;
	function Column_Index(Q : Query_Type; Name : String)
		return Column_Index_Type;
	function Column_Type(Q : Query_Type; CX : Column_Index_Type)
		return Field_Type;

	function Is_Null(Q : Query_Type; CX : Column_Index_Type) return Boolean;
	function Value(Query : Query_Type; CX : Column_Index_Type) return String;
 	-- Returns Result_Type'Pos()  (for generics)

	function Result(Query : Query_Type) return Natural;
	function Result(Query : Query_Type) return Result_Type;
	function Command_Oid(Query : Query_Type) return Row_ID_Type;
	function Null_Oid(Query : Query_Type) return Row_ID_Type;

	function Error_Message(Query : Query_Type) return String;
	function Is_Duplicate_Key(Query : Query_Type) return Boolean;
	function Engine_Of(Q : Query_Type) return Database_Type;


private

   type Connection_Type is new APQ.Root_Connection_Type with
      record
	 Options       : String_Ptr;
	 -- MySQL database engine options
	 Connection    : MYSQL := Null_Connection;
	 -- MySQL connection object
	 Connected     : Boolean := False;
	 -- True when connected
	 Error_Code    : Result_Type;
	 -- Error code (should agree with message)
	 Error_Message : String_Ptr;
	 -- Error message after failed to connect (only)
  	         ----
	 keyname     : String_Ptr_Array_Access; -- see (e.g.)http://dev.mysql.com/doc/refman/5.1/en/mysql-options.html
	 keyval      : String_Ptr_Array_Access; -- or yet more uptodate url,for example of keyname(s) e theirs possible keyvals :-)
	 keyval_type : Argument_Array_Access; -- no need to be a 'Ptr' ! :-)
	 keycount    : natural := 0;
	 keyalloc : natural := 0;

--       keyval_Caseless   : Boolean_Array_Access;
--  	 keyname_Caseless  : Boolean_Array_Access;

	 keyname_val_cache_common   : common_part_record_ptr_array_access  ; -- for bypass "the recreate it"
	 keyname_val_cache_ssl      : ssl_part_record_array_access  ; -- for bypass "the recreate it"
	 keyname_val_cache_uptodate : boolean := false; -- if keyname_val_cache_uptodate = true (True)

--           keyname_default_case : SQL_Case_Type := Lower_Case;
--           keyval_default_case  : SQL_Case_Type := Preserve_Case;
--           ----
      end record;

	procedure Finalize(C : in out Connection_Type);
	procedure Initialize(C : in out Connection_Type);

	type Query_Type is new APQ.Root_Query_Type with
		record
			Results :         APQ.MySQL.MYSQL_RES := Null_Result;
			-- MySQL Query Results (if any)
			Error_Code :      Result_Type;
			-- Error code (should agree with message)
			Error_Message :   String_Ptr;
			-- Error message after failed to connect (only)
			Row :             APQ.MySQL.MYSQL_ROW := Null_Row;
			-- The current/last row fetched
			Row_ID :          Row_ID_Type;
			-- Row ID from last INSERT/UPDATE
		end record;

	procedure Initialize(Q : in out Query_Type);
	procedure Adjust(Q : in out Query_Type);
   procedure Finalize(Q : in out Query_Type);

end APQ.MySQL.Client;

-- End $Source: /cvsroot/apq/apq/apq-mysql-client.ads,v $
