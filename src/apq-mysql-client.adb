------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--                              A P Q - MYSQL  				    --
--                                                                          --
--                                 B o d y                                  --
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

with Ada.Text_IO; 		use Ada.Text_IO;
with Ada.Exceptions;		use Ada.Exceptions;
with Ada.Strings.Unbounded;
with Ada.Characters.Handling;
with Ada.IO_Exceptions;
with Interfaces.C.Strings;


package body APQ.MySQL.Client is

        type Field_Count_Type is mod 2 ** 32;

        procedure my_init;
	pragma import(C,my_init,"c_my_init");

	function mysql_init return MYSQL;
	pragma import(C,mysql_init,"c_mysql_init");

        function mysql_connect(conn : MYSQL; host, user, passwd,
		db : system.address; port : Port_Integer;
		local_socket : system.address) return Return_Status;
	pragma import(C,mysql_connect,"c_mysql_connect");

        function mysql_is_connected(conn : MYSQL ) return Integer;
	pragma Import( C, mysql_is_connected, "c_mysql_is_connected" );

	function mysql_close(C : MYSQL) return MYSQL;
	pragma import(C,mysql_close,"c_mysql_close");

	function mysql_errno(C : MYSQL) return Result_Type;
	pragma import(C,mysql_errno,"c_mysql_errno");

	function mysql_error(C : MYSQL)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_error,"c_mysql_error");

        function cheat_mysql_error(results : MYSQL_RES)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,cheat_mysql_error,"c_cheat_mysql_error");

	function cheat_mysql_errno(results : MYSQL_RES) return Result_Type;
	pragma import(C,cheat_mysql_errno,"c_cheat_mysql_errno");

        function mysql_port(C : MYSQL) return Integer;
	pragma import(C,mysql_port,"c_mysql_port");

	function mysql_unix_socket(C : MYSQL)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_unix_socket,"c_mysql_unix_socket");

        function mysql_select_db(C : MYSQL; Database : System.Address)
		return Return_Status;
	pragma import(C,mysql_select_db,"c_mysql_select_db");

        function mysql_get_host_name(C : MYSQL)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_get_host_name,"c_mysql_get_host_name");

        function mysql_query(conn : MYSQL; query : System.Address)
		return Return_Status;
	pragma import(C,mysql_query,"c_mysql_query");

        function mysql_use_result(conn : MYSQL) return MYSQL_RES;
	pragma import(C,mysql_use_result,"c_mysql_use_result");

	function mysql_store_result(conn : MYSQL) return MYSQL_RES;
	pragma import(C,mysql_store_result,"c_mysql_store_result");

	procedure mysql_free_result(result : MYSQL_RES);
	pragma import(C,mysql_free_result,"c_mysql_free_result");

        function mysql_fetch_field(result : MYSQL_RES;
		fieldno : Interfaces.C.int) return MYSQL_FIELD;
	pragma import(C,mysql_fetch_field,"c_mysql_fetch_field");

	function mysql_field_count(conn : MYSQL) return Field_Count_Type;
	pragma import(C,mysql_field_count,"c_mysql_field_count");

	function mysql_field_name(field : MYSQL_FIELD)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_field_name,"c_mysql_field_name");

	function mysql_field_type(field : MYSQL_FIELD) return Field_Type;
	pragma import(C,mysql_field_type,"c_mysql_field_type");

	function mysql_field_value(result : MYSQL_RES; row : MYSQL_ROW;
		fieldno : Interfaces.C.int)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_field_value,"c_mysql_field_value");

        function mysql_fetch_row(result : MYSQL_RES) return MYSQL_ROW;
	pragma import(C,mysql_fetch_row,"c_mysql_fetch_row");

	function mysql_fetch_row_direct(result : MYSQL_RES;
		row_no : MYSQL_ROW_NO) return MYSQL_ROW;
	pragma import(C,mysql_fetch_row_direct,"c_mysql_fetch_row_direct");

	function mysql_num_rows(result : MYSQL_RES) return MYSQL_ROW_NO;
	pragma import(C,mysql_num_rows,"c_mysql_num_rows");

        function mysql_sqlstate(conn : MYSQL)
		return Interfaces.C.Strings.chars_ptr;
	pragma import(C,mysql_sqlstate,"c_mysql_sqlstate");

        function mysql_eof(results : MYSQL_RES) return Interfaces.C.int;
	pragma import(C,mysql_eof,"c_mysql_eof");

        function mysql_num_fields(results : MYSQL_RES)
		return Interfaces.C.int;
	pragma import(C,mysql_num_fields,"c_mysql_num_fields");

        function mysql_fetch_field_direct(results : MYSQL_RES;
		x : Interfaces.C.int) return MYSQL_FIELD;
	pragma import(C,mysql_fetch_field_direct,
		"c_mysql_fetch_field_direct");

        function mysql_name_index(results : MYSQL_RES;
		name : System.Address) return Interfaces.C.int;
	pragma import(C,mysql_name_index,"c_mysql_name_index");

        function mysql_get_field_type(results : MYSQL_RES;
		x : Interfaces.C.int) return Field_Type;
	pragma import(C,mysql_get_field_type,"c_mysql_get_field_type");

        function mysql_insert_id(connection : MYSQL) return MySQL_Oid_Type;
	pragma import(C,mysql_insert_id,"c_mysql_insert_id");

        function mysql_real_escape_string(connection : MYSQL;
		to, from : System.Address; length : u_long) return u_long;
	pragma import(C,mysql_real_escape_string,"c_mysql_real_escape_string");

   function mysql_options_nonspecif(connection : MYSQL;
				    opt : interfaces.c.unsigned;
				    arg : System.Address
				      )	return Interfaces.C.int;
   pragma import(C,mysql_options_nonspecif,"c_mysql_options_nonspecif");


   function my_set_ssl(conn : MYSQL;
		       kkey,ccert,cca,ccapath,ccipher: system.Address
		      ) return Interfaces.C.int ;
   pragma import(c,my_set_ssl ,"c_mysql_ssl_set_v2");



        procedure Free(Results : in out MYSQL_RES) is
	begin
		mysql_free_result(Results);
		Results := Null_Result;
	end Free;


	function Name_Of(Field : MYSQL_FIELD) return String is
		use Interfaces.C.Strings, Interfaces.C;
	begin
		return To_Ada(Value(mysql_field_name(Field)));
	end Name_Of;


	function Type_Of(Field : MYSQL_FIELD) return Field_Type is
	begin
		return mysql_field_type(Field);
	end Type_Of;


 	function Value_Of(Results : MYSQL_RES; Row : MYSQL_ROW;
 		Column_Index : Column_Index_Type) return Interfaces.C.Strings.chars_ptr is

		use Interfaces.C;
        begin
		return mysql_field_value(Results,Row,Interfaces.C.Int(Column_Index)-1);
	end Value_Of;



	procedure Clear_Error(C : in out Connection_Type) is
	begin
		C.Error_Code := CR_NO_ERROR;
		Free(C.Error_Message);
	end Clear_Error;

	procedure Clear_Error(Q : in out Query_Type;
		C : in out Connection_Type) is
	begin
		C.Error_Code := CR_NO_ERROR;
		Free(C.Error_Message);

		Q.Error_Code := C.Error_Code;
		Free(Q.Error_Message);
	end Clear_Error;


	procedure Post_Error(C : in out Connection_Type) is
		use Interfaces.C, Interfaces.C.Strings;
		Error_Msg : String := To_Ada(Value(mysql_error(C.Connection)));
	begin
		C.Error_Code := mysql_errno(C.Connection);
		Replace_String(C.Error_Message,Error_Msg);
	end Post_Error;



	------------------------------
	-- INTERNAL :
	------------------------------
	-- This one cheats because here
	-- we have no access to the
	-- Connection_Type object.
	------------------------------
	procedure Post_Error(Q : in out Query_Type) is
		use Interfaces.C, Interfaces.C.Strings;
		Error_Msg : String := To_Ada(Value(cheat_mysql_error(Q.Results)));
	begin
		if Q.Results = Null_Result then
			Q.Error_Code := CR_NO_ERROR;
			Free(Q.Error_Message);
		else
			Q.Error_Code := cheat_mysql_errno(Q.Results);
			Replace_String(Q.Error_Message,Error_Msg);
		end if;
	end Post_Error;

	procedure Post_Error(Q : in out Query_Type; C : in out Connection_Type) is
		use Interfaces.C, Interfaces.C.Strings;
		Error_Msg : String := To_Ada(Value(mysql_error(C.Connection)));
	begin

		C.Error_Code := mysql_errno(C.Connection);
		Replace_String(C.Error_Message,Error_Msg);

		Q.Error_Code := C.Error_Code;
		if C.Error_Message /= null then
			Replace_String(Q.Error_Message,Error_Msg);
		else
			Free(Q.Error_Message);
		end if;
	end Post_Error;



	procedure Clear_Results(Q : in out Query_Type) is
	begin
		if Q.Results /= Null_Result then
			Free(Q.Results);
		end if;

		Q.Row := Null_Row;
	end Clear_Results;

	function Is_Column(Q : Query_Type; CX : Column_Index_Type) return Boolean is
		Cols : Natural := Columns(Q);
	begin
		return Natural(CX) >= 1 and then Natural(CX) <= Cols;
	end Is_Column;






        ---------------------------
        -- DATABASE CONNECTION : --
        ---------------------------


	function Engine_Of(C : Connection_Type) return Database_Type is
	begin
		return Engine_MySQL;
	end Engine_Of;


	function New_Query(C : Connection_Type) return Root_Query_Type'Class is
		Q : Query_Type;
	begin
		return Q;
	end New_Query;


	procedure Set_DB_Name(C : in out Connection_Type; DB_Name : String) is
	begin
		if not Is_Connected(C) then
			Set_DB_Name(Root_Connection_Type(C),To_Case(DB_Name,C.SQL_Case));
		else
			declare
				use Interfaces.C;
				Use_Database : char_array := To_C(DB_Name);
			begin
				if mysql_select_db(C.Connection,Use_Database'Address) /= 0 then
					Set_DB_Name(Root_Connection_Type(C),To_Case(DB_Name,C.SQL_Case));
				else
					Raise_Exception(Use_Error'Identity,
					"MY02: Unable to select database '" & DB_Name & "' (Set_DB_Name).");
				end if;
			end;
		end if;
	end Set_DB_Name;


	function Port(C : Connection_Type) return Integer is
	begin
		if not Is_Connected(C) then
			return Port(Root_Connection_Type(C));
		else
			return mysql_port(C.Connection);
		end if;
	end Port;


	function Port(C : Connection_Type) return String is
		use Interfaces.C, Interfaces.C.Strings;
	begin
		if not Is_Connected(C) then
			return Port(Root_Connection_Type(C));
		else
			return To_Ada(Value(mysql_unix_socket(C.Connection)));
		end if;
	end Port;


	procedure Set_Instance(C : in out Connection_Type; Instance : String) is
	begin
		Raise_Exception(Not_Supported'Identity,
		"MY01: MySQL has no Instance ID (Set_Instance).");
	end Set_Instance;

   procedure Set_Options(C : in out Connection_Type; Options : String) is
   begin
   	Raise_Exception(Not_Supported'Identity,
		    "MY01: MySQL, Set_Options() is obsolete. use add_key_nameval() (Set_Options).");
   end Set_Options;

   function Options(C : Connection_Type) return String is
   begin

      Raise_Exception(Not_Supported'Identity,
		"MY01: MySQL, options() is obsolete. use add_key_nameval() (Options).");
   end Options;
   ------------
   function return_address_type( ustring : ada.Strings.Unbounded.Unbounded_String;
				 argtype : Option_Argument_Type
				) return system.Address
   is
      my_char_array: char_array := To_C(string'(to_string(ustring)));

   begin
      case argtype is
      when ARG_CHAR_PTR => -- char_array ?
	 --return ( new char_array'(To_C(string'(to_string(ustring)))))'Address; -- or
	 --return (char_array_access'( new char_array'(my_char_array'range => my_char_array)))'Address; -- or just
			   -- return (char_array'(To_C(string'(to_string(ustring)))))'Address; -- ?
	 return my_char_array'Address;

      when ARG_NOT_USED =>
	 -- return (unsigned_int_ptr'( new Interfaces.c.unsigned(0)))'Address;
	 return Interfaces.c.unsigned(0)'Address;

      when ARG_UINT =>
	 return interfaces.c.unsigned'Value(string'(to_string(ustring)))'Address;

      when ARG_PTR_UINT =>
	 if interfaces.c.unsigned'Value(string'(to_string(ustring))) /= 0 then
	    return Interfaces.c.unsigned(1)'Address;
	 else
	    return Interfaces.c.unsigned(0)'Address;
	 end if;

      when others =>
	 return system.Null_Address;

      end case;

   --  exception  part in off, for testing purposes.
--     Exception
--  	 when Constraint_Error => return system.Null_Address;
   end return_address_type;

   function quote_string( qkv : string ) return String
   is
      use ada.Strings;
      use ada.Strings.Fixed;

      function mysql_escape_string( to, from : System.Address; length : u_long) return u_long;
      pragma import(C,mysql_escape_string,"c_mysql_escape_string");
      src : string := trim ( qkv , both );
      C_Length : u_long := src'Length * 2 + 1;
      C_From   : char_array := To_C(src);
      C_To     : char_array(0..C_Length-1);
      R_Length : u_long := mysql_escape_string(C_To'Address,C_From'Address,C_Length);
      -- viva!!! :-)
   begin
      return To_Ada(C_To);
   end quote_string;
   ----

   function quote_string( qkv : string ) return ada.Strings.Unbounded.Unbounded_String
   is
   begin
      return ada.Strings.Unbounded.To_Unbounded_String(String'(quote_string(qkv)));
   end quote_string;

   --
   procedure grow_key (C  : in out Connection_Type) is
      -- used internally to grow the key name and respective val size so add_keyname_val() works;
      -- not alter c.keyname_val_cache_uptodate here :-) because It don't yet insert new "real" change
      -- in c.keyname_val_cache :-)
      pragma optimize(time);

   begin
      if C.keycount <= 0 and c.keyalloc <= 0 then

         C.keyalloc := 32; -- this suffice for now :-)

         C.keyname := new String_Ptr_Array(1..C.keyalloc);
	 C.keyval  := new String_Ptr_Array(1..C.keyalloc);
	 C.keyval_type := new Option_Argument_Ptr_Array(1..C.keyalloc);

         C.keyname_Caseless  := new Boolean_Array(1..C.keyalloc);
         C.keyval_Caseless   := new Boolean_Array(1..C.keyalloc);

      elsif C.keycount >= C.keyalloc then
         declare
            New_keyAlloc : Natural := C.keyAlloc + 64;
            New_Array_keyname : String_Ptr_Array_Access := new String_Ptr_Array(1..New_keyAlloc);
	    New_Array_keyval  : String_Ptr_Array_Access := new String_Ptr_Array(1..New_keyAlloc);
	    New_Array_Keyval_Type : Option_Argument_Ptr_Array_Access := new Option_Argument_Ptr_Array(1..New_keyAlloc);

            New_Case_keyname  : Boolean_Array_Access    := new Boolean_Array(1..New_keyAlloc);
            New_Case_keyval   : Boolean_Array_Access    := new Boolean_Array(1..New_keyAlloc);

         begin
            New_Array_keyname(1..C.keyalloc) := C.keyname.all;
	    New_Array_keyval(1..C.keyalloc) := C.keyval.all;
	    New_Array_Keyval_Type(1..C.keyalloc) := C.keyval_type.all;

            New_Case_keyname(1..C.keyalloc) := C.keyname_Caseless.all;
            New_Case_keyval(1..C.keyalloc)  := C.keyval_Caseless.all;

            Free(C.keyname);
	    Free(C.keyval);
	    Free(C.keyval_type);
            Free(C.keyname_Caseless);
            Free(C.keyval_Caseless);

            C.keyAlloc := New_keyAlloc;

            C.keyname := New_Array_keyname;
	    C.keyval := New_Array_keyval;
	    C.keyval_type := New_Array_Keyval_Type;

            C.keyname_Caseless := New_Case_keyname;
            C.keyval_Caseless := New_Case_keyval;

         end;
      end if;
   end grow_key;--
   --
   function cache_key_nameval_uptodate( C : Connection_Type) --
                                       return boolean
   is
   begin
      return c.keyname_val_cache_uptodate;
      -- fixme: proper exception/error handler  :-)
   end cache_key_nameval_uptodate;

   --
   procedure cache_key_nameval_create( C : in out Connection_Type; force : boolean := false)--
   is
      pragma optimize(time);

      use ada.strings.Unbounded;
      use ada.strings.Fixed;
      use ada.Strings;
      use Ada.Characters.Handling;

      a : natural := c.keycount; -- number of keyname's and keyval's
      bool1 : bool := false;
      -- mint : integer := 0;
      mi_count : integer := 0;
      new_option_enum : option_enum_type_array_ptr := new option_enum_type_array'( others => system.Null_Address);
      new_specific_enum : specific_type_array_ptr := new specific_type_array'( others => system.Null_Address);
      tmp_ub_dont_know_options : Unbounded_String := To_Unbounded_String(160);
      tmp_ub_keyname : Unbounded_String := To_Unbounded_String(30);
      tmp_ub_keyval : Unbounded_String := To_Unbounded_String(30);

   begin
      if cache_key_nameval_uptodate( C ) and force = false then return; end if; -- bahiii :-)
      Free(c.keyname_val_cache_nonspe0);
      Free(c.keyname_val_cache_spec1);

      if not (c.Port_Format = UNIX_Port or c.Port_Format = IP_Port ) then
         raise program_error;
      end if;

      if not( a > 0 ) then
	 c.keyname_val_cache_uptodate := true;
	 return; -- bahiii :-)
      end if;

      for b in 1 .. a loop
	 tmp_ub_keyname := trim(Unbounded_String'(To_Unbounded_String(string'(To_String(C.keyname(b))))),ada.Strings.both);

	 if c.keyval_type(b) = ARG_CHAR_PTR then
            if c.keyval_Caseless(b) or c.keyval_default_case = Preserve_Case then
               tmp_ub_keyval := tmp_ub_cache & trim(Unbounded_String'(quote_string(string'(To_String(C.keyval(b))))),ada.Strings.both);
            else
               if c.keyname_default_case = Lower_Case then
                  tmp_ub_keyval := trim(Unbounded_String'(quote_string(To_Lower(string'(To_String(C.keyval(b)))))),ada.Strings.both);
               else
                  tmp_ub_keyval := trim(Unbounded_String'(quote_string(To_Upper(string'(To_String(C.keyval(b)))))),ada.Strings.both);
               end if;
	    end if;
	 else
	    tmp_ub_keyval := trim(Unbounded_String'(To_Unbounded_String(string'(To_String(C.keyval(b))))),ada.Strings.both);
	 end if;
	 bool1 := false;

	 declare -- verify, non-specific
	    I_am : Option_Enum_Type := Option_Enum_Type'value(to_string(tmp_ub_keyname));
	 begin
	    if new_option_enum(I_am).all /= system.Null_Address then
	       free(new_option_enum(I_am)); --
	    end if;
	    new_option_enum(I_am).all := return_address_type(ustring => tmp_ub_keyval,
						  argtype => c.keyval_type(b) );
	    bool1 := true;
	    goto continua; -- well... really judicious, this was my the better option :-)
	 exception
	    when constraint_error =>
	       bool1 := false;
	 end; -- non-specific

	 declare -- verify, specific , ssl
	    I_am : ssl_Specific_Type := ssl_Specific_Type'value(to_string(tmp_ub_keyname));
	 begin
	    if new_specific_enum(ssl).all = system.Null_Address then
	       declare
		  my_ssl_spec : ssl_Specific_Type_Array_Ptr := new ssl_Specific_Type_Array'( others => system.Null_Address);
	       begin
		  new_specific_enum(ssl).all := my_ssl_spec'Address;
		--  w_specific_enum(ssl).all := ((
--  		 ssl_Specific_Type_Array_Ptr'(
--  		   new ssl_Specific_Type_Array'( others => system.Null_Address))
--  		))'Address;
--  	       ((
--  		 ssl_Specific_Type_Array_Ptr'(
--  		   new ssl_Specific_Type_Array( others => system.Null_Address))
--  		).all)'Address; -- ".all" ?
	       end;
	    end if;
	    if new_specific_enum(ssl).all(I_am).all /= system.Null_Address then
	       free(new_specific_enum(ssl).all(I_am)); -- there are a free() for char_array/char_array_access in apq.ads :-)
	    end if;
	    declare
	       my_char_array_access: char_array_access := new char_array'(to_C(string'(to_string(tmp_ub_keyval)))); --
	    begin
	       new_specific_enum(ssl).all(I_am).all := my_char_array_access'Address;
	    end;

	    bool1 := true; -- ((char_array_access'(new char_array'(to_C(string'(to_string(tmp_ub_keyval)))))).all)'Address;
	    goto continua; -- well... really judicious, this was my the better option :-)
	    -- more specific options can be added in future. :-)
	 exception
	    when constraint_error =>
	       bool1 := false;
	 end; -- specific , ssl
       -- more specific options from here

	 <<continua>>
	 if bool1 = false then
	    mi_count := mi_count + 1 ;
	    if mi_count = 1 then
	       tmp_ub_dont_know_options := tmp_ub_keyname ;
	    else
	       tmp_ub_dont_know_options := tmp_ub_dont_know_options & " , " & tmp_ub_keyname ;
	    end if;
	 end if;

      end loop;

      if mi_count > 0 then
	 if mi_count < a then
	    for I_am in Option_Enum_Type'range loop
	       if  new_option_enum(I_am).all /= system.Null_Address then
		   free(new_option_enum(I_am).all);
	       end if;
	    end loop;
	    for I_am in Specific_Type'range loop
	       if  new_specific_enum(I_am).all /= system.Null_Address then
		   free(new_specific_enum(I_am).all);
	       end if;
	    end loop;
	 end if;
	 free(new_option_enum);
	 free(new_specific_enum);

	 Raise_Exception(Failed'Identity ,
		  "MY03: Unkown option(s) ' " & string'(to_string(tmp_ub_dont_know_options)) & " ' " );
	 return; -- :o]
      end if;

      C.keyname_val_cache_nonspe0 := new_option_enum;
      C.keyname_val_cache_spec1 := new_specific_enum;
      C.keyname_val_cache_uptodate := true;

   end cache_key_nameval_create;
   --
   procedure clear_all_key_nameval(C : in out Connection_Type; add_more_this_alloc : natural := 0)
   is
      pragma optimize(time);

      ckcount : natural := c.keycount;
      ckalloc : natural := c.keyalloc;
      len     : natural := ckalloc;

   begin
      if ckcount = 0 and add_more_this_alloc = 0 and ckalloc /= 0 then
         return;  -- bahiii :-)
      end if;

      pragma assert( add_more_this_alloc > 200 ); -- uau ! :-)

      ckcount := ckcount + add_more_this_alloc;
      if ckcount >= ckalloc then
         ckalloc := ckcount + 32 ;
         len := ckalloc;
      end if;

      declare
         New_Array_keyname : String_Ptr_Array_Access := new String_Ptr_Array(1..len);
	 New_Array_keyval  : String_Ptr_Array_Access := new String_Ptr_Array(1..len);
	 New_Array_Keyval_Type : Option_Argument_Ptr_Array_Access := new Option_Argument_Ptr_Array(1..len);

         New_Case_keyname  : Boolean_Array_Access    := new Boolean_Array(1..len);
         New_Case_keyval   : Boolean_Array_Access    := new Boolean_Array(1..len);

      begin
         Free(C.keyname);
	 Free(C.keyval);
	 Free(C.keyval_type);
         Free(C.keyname_Caseless);
         Free(C.keyval_Caseless);

         C.keycount := 0;

         C.keyname := New_Array_keyname;
         C.keyval := New_Array_keyval;

         C.keyname_Caseless := New_Case_keyname;
         C.keyval_Caseless := New_Case_keyval;

         C.keyname_val_cache_uptodate := false;

         C.keyalloc := len;

      end ;
   end clear_all_key_nameval;


   procedure add_key_nameval( C : in out Connection_Type;
			     kname, kval : string := "";
			     kval_type : Option_Argument_Type := ARG_CHAR_PTR ;
                             knamecasele, kvalcasele : boolean := true;
                            clear : boolean := false )
   is
      pragma optimize(time);
      use ada.strings;
      use ada.Strings.Fixed;

      tmp_kname : string  := string'(trim(kname,both));
      tmp_kval  : string  := string'(trim(kval,both));
      tkm       : natural := tmp_kname'Length;
      tkv       : natural := tmp_kval'Length;
      ckc       : natural := 0;
   begin
      if clear then
         clear_all_key_nameval(C);
      end if;
      if tmp_kname = "" then return; end if; -- bahiii :-)
      grow_key(C);
      C.keycount := C.keycount + 1;
      ckc := C.keycount;
      C.keyname(ckc) := new String(1..tkm);
      C.keyname(ckc).all(1..tkm) := tmp_kname;
      C.keyname_Caseless(ckc) := knamecasele;
      if tmp_kval = "" then
         C.keyval(ckc) := null;
      else
         C.keyval(ckc) := new String(1..tkv);
         C.keyval(ckc).all(1..tkv) := tmp_kval;
      end if;
      C.keyval_type(ckc) := kval_type; --
      C.keyval_Caseless(ckc)       := kvalcasele;
      C.keyname_val_cache_uptodate := false;

   end add_key_nameval;

   function get_keyname_default_case( C : Connection_Type) return SQL_Case_Type--
   is
   begin
      return c.keyname_default_case;
      -- fixme: proper exception/error handler  :-)
   end get_keyname_default_case;

   function get_keyval_default_case( C : Connection_Type) return SQL_Case_Type--
   is
   begin
      return c.keyval_default_case;
      -- fixme: proper exception/error handler  :-)
   end get_keyval_default_case;

   procedure set_keyname_default_case( C : in out Connection_Type; sqlcase: SQL_Case_Type)--
   is
   begin
      c.keyname_default_case := sqlcase;

      -- fixme: are there necessity to invalidate
      -- the keyname_val_cache ? if yes, uncomment the line below :-)
      -- C.keyname_val_cache_uptodate := false;
   end set_keyname_default_case;

   procedure set_keyval_default_case( C : in out Connection_Type; sqlcase: SQL_Case_Type)
   is
   begin
      c.keyval_default_case := sqlcase;
      -- fixme: are there necessity to invalidate
      -- the keyname_val_cache ? if yes, uncomment the line below :-)
      -- C.keyname_val_cache_uptodate := false;
   end set_keyval_default_case;
   --
   procedure clone_clone_my(To : in out Connection_Type; From : Connection_Type )
   is
      pragma optimize(time);

      keyalloc_from : natural := from.keyalloc;
      keycount_from : natural := from.keycount;
      keyalloc_to   : natural := to.keyalloc;
      keycount_to   : natural := to.keycount;

   begin
      if keycount_from = 0 or keyalloc_from = 0 then
         clear_all_key_nameval(To);
         return; -- bahiii :-)
      end if;

      if keycount_from >= keyalloc_to then
         clear_all_key_nameval(to , add_more_this_alloc => (keycount_from - keyalloc_to) + 1 );
      else
         clear_all_key_nameval(to);
      end if;
      declare
         len        : natural := keycount_from;
         New_Array_keyname : String_Ptr_Array_Access := new String_Ptr_Array(1..len);
	 New_Array_keyval  : String_Ptr_Array_Access := new String_Ptr_Array(1..len);
	 New_Array_Keyval_Type : Option_Argument_Ptr_Array_Access := new Option_Argument_Ptr_Array(1..len);

         New_Case_keyname  : Boolean_Array_Access    := new Boolean_Array(1..len);
         New_Case_keyval   : Boolean_Array_Access    := new Boolean_Array(1..len);

      begin
         New_Array_keyname.all := from.keyname.all;
	 New_Array_keyval.all  := from.keyval.all;
	 New_Array_keyval_Type.all  := from.keyval_type.all;

         New_Case_keyname.all  := from.keyname_Caseless.all;
         New_Case_keyval.all  := from.keyval_Caseless.all;

         to.keyname(1..len) := New_Array_keyname.all;
	 to.keyval(1..len) := New_Array_keyval.all;
	 to.keyval_type(1..len) := New_Array_Keyval_Type.all;

         to.keyname_Caseless(1..len) := New_Case_keyname.all;
         to.keyval_Caseless(1..len) := New_Case_keyval.all;

         to.keyname_val_cache_uptodate := false;

         to.keycount := len;

      end ;
   end clone_clone_my;
 --
--     procedure connect(C : in out Connection_Type; Check_Connection : Boolean := True)
--     is
--        pragma optimize(time);
--
--        use Interfaces.C.Strings;
--
--     begin
--        if Check_Connection and then Is_Connected(C) then
--           Raise_Exception(Already_Connected'Identity,
--                           "PG07: Already connected (Connect).");
--        end if;
--
--        cache_key_nameval_create(C); -- don't worry :-) "re-create" accours only if not uptodate :-)
--                                     -- This procedure can be executed manually if you desire :-)
--                                     -- "for example": the "Connection_type" var was created  and configured
--                                     -- much before the  connection with the DataBase server :-) take place
--                                     -- then the "Connection_type" already uptodate
--                                     -- ( well... uptodate if really uptodate ;-)
--                                     -- this will speedy up the things a little :-)
--        declare
--           procedure Notice_Install(Conn : PG_Conn; ada_obj_ptr : System.Address);
--           pragma import(C,Notice_Install,"notice_install");
--
--           function PQconnectdb(coni : chars_ptr ) return PG_Conn;
--           pragma import(C,PQconnectdb,"PQconnectdb");
--           coni_str : string := C.keyname_val_cache.all;
--           C_conni : chars_ptr := New_String(Str => coni_str );
--        begin
--           C.Connection := PQconnectdb( C_conni); -- blocking call :-)
--           Free_Ptr(C.Error_Message);
--
--           if PQ_Status(C) /= Connection_OK then  -- if the connecting in a non-blocking fashion,
--              -- there are more option of status needing verification :-)
--              -- it Don't the case here
--              declare
--                 procedure PQfinish(C : PG_Conn);
--                 pragma Import(C,PQfinish,"PQfinish");
--                 Msg : String := Strip_NL(Error_Message(C));
--              begin
--                 PQfinish(C.Connection);
--                 C.Connection := Null_Connection;
--                 C.Error_Message := new String(1..Msg'Length);
--                 C.Error_Message.all := Msg;
--                 Raise_Exception(Not_Connected'Identity,
--                                 "PG08: Failed to connect to database server (Connect). error was: " &
--                                 msg ); -- more descriptive about 'what failed' :-)
--              end;
--           end if;
--
--           Notice_Install(C.Connection,C'Address);	-- Install Connection_Notify handler
--
--           ------------------------------
--           -- SET PGDATESTYLE TO ISO;
--           --
--           -- This is necessary for all of the
--           -- APQ date handling routines to
--           -- function correctly. This implies
--           -- that all APQ applications programs
--           -- should use the ISO date format.
--           ------------------------------
--           declare
--              SQL : Query_Type;
--           begin
--              Prepare(SQL,"SET DATESTYLE TO ISO");
--              Execute(SQL,C);
--           exception
--              when Ex : others =>
--                 Disconnect(C);
--                 Reraise_Occurrence(Ex);
--           end;
--        end;
--
--     end connect;
--
--     procedure connect(C : in out Connection_Type; Same_As : Root_Connection_Type'Class)
--     is
--        pragma optimize(time);
--
--        type Info_Func is access function(C : Connection_Type) return String;
--
--        procedure Clone(S : in out String_Ptr; Get_Info : Info_Func) is
--           Info : String := Get_Info(Connection_Type(Same_As));
--        begin
--           if Info'Length > 0 then
--              S	:= new String(1..Info'Length);
--              S.all	:= Info;
--           else
--              null;
--              pragma assert(S = null);
--           end if;
--        end Clone;
--        blo : boolean := true;
--        tmpex : natural := 2;
--     begin
--        Reset(C);
--
--        Clone(C.Host_Name,Host_Name'Access);
--
--        C.Port_Format := Same_As.Port_Format;
--        if C.Port_Format = IP_Port then
--           C.Port_Number := Port(Same_As);	  -- IP_Port
--        else
--           Clone(C.Port_Name,Port'Access);	  -- UNIX_Port
--        end if;
--
--        Clone(C.DB_Name,DB_Name'Access);
--        Clone(C.User_Name,User'Access);
--        Clone(C.User_Password,Password'Access);
--        Clone(C.Options,Options'Access);
--
--        C.Rollback_Finalize	:= Same_As.Rollback_Finalize;
--        C.Notify_Proc		:= Connection_Type(Same_As).Notify_Proc;
--        -- I believe if "Same_As" var is defacto a "Connection_Type" as "C" var,
--        -- there are need for copy  key's name and val from "Same_As" ,
--        -- because in this keys and vals
--        -- maybe are key's how sslmode , gsspi etc, that are defacto needs for connecting "C"
--
--        if Same_As.Engine_Of = Engine_PostgreSQL then
--           clone_clone_my(C , Connection_Type(Same_as));
--        end if;
--
--       connect(C);	-- Connect to database before worrying about trace facilities
--
--        -- TRACE FILE & TRACE SETTINGS ARE NOT CLONED
--
--     end connect;

   function verifica_conninfo_cache( C : Connection_Type) return string -- for debug purpose :-P
                                                                        -- in the spirit there are an get_password(c) yet...

   is
   begin
      return "";
      --- return To_String(c.keyname_val_cache); fixme
   end verifica_conninfo_cache;


   -------------------------------

--     procedure Connect_old(C : in out Connection_Type; Check_Connection : Boolean := True) is
--        pragma Optimize(time);
--
--  		use Interfaces.C.Strings;
--
--  		C_Host :       char_array_access;
--  		A_Host :       System.Address := System.Null_Address;
--  		C_Dbname :     char_array_access;
--  		A_Dbname :     System.Address := System.Null_Address;
--  		C_Login :      char_array_access;
--  		A_Login :      System.Address := System.Null_Address;
--  		C_Pwd :        char_array_access;
--  		A_Pwd :        System.Address := System.Null_Address;
--  		C_Port :       Port_Integer := C.Port_Number;
--  		C_Unix :       char_array_access;
--  		A_Unix :       System.Address := System.Null_Address;
--
--  	begin
--
--  		Clear_Error(C);
--
--  		if Check_Connection and then Is_Connected(C) then
--  			Raise_Exception(Already_Connected'Identity,
--  			"MY08: Object is already connected to database server (Connect).");
--  		end if;
--
--  		if C.Port_Format = IP_Port and then C.Port_Number <= 0 then
--  			Raise_Exception(Not_Connected'Identity,
--  			"MY09: Missing or bad port number for a connect (Connect).");
--  		end if;
--
--  		C_String(C.Host_Name,C_Host,A_Host);
--  		C_String(C.DB_Name,C_Dbname,A_Dbname);
--  		C_String(C.User_Name,C_Login,A_Login);
--  		C_String(C.User_Password,C_Pwd,A_Pwd);
--
--  		case C.Port_Format is
--  			when IP_Port =>
--  				null;
--  			when UNIX_Port =>
--  				C_Port := 0;
--  				-- Zero indicates to mysql_connect() that we are using unix socket
--
--  				C_String(C.Port_Name,C_Unix,A_Unix);
--  		end case;
--
--  		--
--  		-- Must re-establish a C.Connection after a Disconnect/Reset (object reuse)
--  		--
--  		if C.Connection = Null_Connection then
--  			C.Connection := mysql_init;      -- Needed after disconnects
--  		end if;
--  			C.Connected := mysql_connect(
--  			conn 	=> C.Connection,  -- Connection object
--  			host	=> A_Host,        -- host or IP #
--  			user	=> A_Login,       -- user name
--  			passwd	=> A_Pwd,         -- password
--  			db	=> A_Dbname,      -- database
--  			port	=> C_Port,        -- IP Port # or zero
--  			local_socket  => A_Unix   -- UNIX socket name or null
--  				)   /= 0;
--
--  		if C_Host /= null then
--  			Free(C_Host);
--  		end if;
--  			if C_Dbname /= null then
--  			Free(C_Dbname);
--  		end if;
--  			if C_Login /= null then
--  			Free(C_Login);
--  		end if;
--
--  		if C_Pwd /= null then
--  			Free(C_Pwd);
--  		end if;
--  			if C_Unix /= null then
--  			Free(C_Unix);
--  		end if;
--  			if not C.Connected then
--  			Post_Error(C);
--  			Raise_Exception(Not_Connected'Identity,
--  				"MY10: Failed to connect to database server (Connect).");
--  		else
--  			declare
--  				use Interfaces.C, Interfaces.C.Strings;
--
--  				Host_Name : String := To_Ada(Value(mysql_get_host_name(C.Connection)));
--  			begin
--  				Replace_String(C.Host_Name,Host_Name);
--  			end;
--
--  			declare
--  				use Interfaces.C, Interfaces.C.Strings;
--
--  				UNIX_Socket : String := To_Ada(Value(mysql_unix_socket(C.Connection)));
--  			begin
--  				if UNIX_Socket /= "" then
--  					C.Port_Format := UNIX_Port;
--  					Replace_String(C.Port_Name,UNIX_Socket);
--  					-- Update socket pathname
--  				else
--  					C.Port_Format := IP_Port;
--  					C.Port_Number := mysql_port(C.Connection);
--  					-- Update port number used
--
--  					if C.Port_Name /= null then
--  						Free(C.Port_Name);
--  					end if;
--  				end if;
--  			end;
--
--  			if C.Options /= null then
--  				Process_Connection_Options(C);
--  			end if;
--  		end if;
--  	end Connect_old;
--     ---------------------------------
   procedure my_process_options( C : Connection_Type )
   is
      use ada.strings.Unbounded;
      tmp_ub_dont_know_options : Unbounded.Unbounded_String := To_Unbounded_String(50);
      mi_count : Integer := 0;
   begin
      if  C.Connection = Null_Connection then return; end if; -- bahiii ! :-)
      if C.keyname_val_cache_nonspe0 = null and
	C.keyname_val_cache_spec1 = null
      then
	 return;
      end if;
      if C.keyname_val_cache_nonspe0 /= null then
	 for a in C.keyname_val_cache_nonspe0.all'range(1) loop
	    if C.keyname_val_cache_nonspe0(a).all /= Null_Address then
	       if mysql_options_nonspecif(connection => C.Connection,
				   opt        => toUnsigned(a),
				   arg        => C.keyname_val_cache_nonspe0(a).all
				  ) = 0
	       then
		  mi_count := mi_count + 1 ;
		  if mi_count = 1 then
		     tmp_ub_dont_know_options := To_Unbounded_String(" error Key '") & Option_Enum_Type'image(a) &
		       To_Unbounded_String("' => value ' ") & C.keyname_val_cache_nonspe0(a).all'img ; -- string'value( ) ?
		  else
		     tmp_ub_dont_know_options := tmp_ub_dont_know_options & " , " & To_Unbounded_String(" error Key '") &
		       Option_Enum_Type'image(a) & To_Unbounded_String("' => value ' ") & C.keyname_val_cache_nonspe0(a).all'img ;
		  end if;
	       end if;
	    end if;
	 end loop;
      end if;
      if C.keyname_val_cache_spec1 /= null then
	 if C.keyname_val_cache_spec1(ssl).all /= system.Null_Address then
	    declare
	       b : renames C.keyname_val_cache_spec1(ssl).all ;
	    begin -- key , cert , ca , capath, cipher
	       if my_set_ssl(conn    => C.Connection,
		      kkey    => b(key) ,
		      ccert   => b(cert),
		      cca     => b(ca),
		      ccapath => b(capath),
		      ccipher => b(cipher) ) = 0
	       then
		  mi_count := mi_count + 1 ;
		  if mi_count /= 1 then
		     tmp_ub_dont_know_options := tmp_ub_dont_know_options & " , " ;
		  end if;
		  tmp_ub_dont_know_options := tmp_ub_dont_know_options &
		    To_Unbounded_String(" (SSL) ==> 'key' => '") & string'(To_Ada( b(key).all)) &
		    To_Unbounded_String("' 'cert' => '") & string'(to_ada( b(cert).all )) &
		    To_Unbounded_String("' 'ca' => '") & string'(to_ada( b(ca).all )) &
		    To_Unbounded_String("' 'capath' => '") & string'(to_ada( b(capath).all )) &
		    To_Unbounded_String("' 'cipher' => '") & string'(to_ada( b(cipher).all )) ;
	       end if;
	    end;
	 end if;
      end if;
      if mi_count > 0 then
	 Raise_Exception(Failed'Identity ,
		  "MY03: Unkown option(s) ' " & string'(to_string(tmp_ub_dont_know_options)) & " ' " );
      end if;

      return; -- :o]

   end my_process_options;

   procedure Connect(C : in out Connection_Type; Check_Connection : Boolean := True) is

      pragma Optimize(time);

      use Interfaces.C, Interfaces.C.Strings;

   begin

      Clear_Error(C);

      if Check_Connection and then Is_Connected(C) then
	 Raise_Exception(Already_Connected'Identity,
		  "MY08: Object is already connected to database server (Connect).");
      end if;

      if C.Port_Format = IP_Port and then C.Port_Number <= 0 then
	 Raise_Exception(Not_Connected'Identity,
		  "MY09: Missing or bad port number for a connect (Connect).");
      end if;

      cache_key_nameval_create(C); -- don't worry :-) "re-create" accours only if not uptodate :-)
                                   -- This procedure can be executed manually if you desire :-)
                                   -- "for example": the "Connection_type" var was created  and configured
                                   -- much before the  connection with the DataBase server :-) take place
                                   -- then the "Connection_type" already uptodate
				   -- ( well... uptodate if really uptodate ;-)
				   -- this will speedy up the things a little :-)

      --
      -- Must re-establish a C.Connection after a Disconnect/Reset (object reuse)
      --
      if C.Connection = Null_Connection then
	 C.Connection := mysql_init;      -- Needed after disconnects
      end if;

      my_process_options( C ); -- ToDo: need a exception handler. this suffice for now :-)

      if c.Port_Format = IP_Port then
	 declare
	    host : char_array := to_c( C.Host_Address.all );
	    port : unsigned := unsigned( C.Port_Number );
	    user : char_array := to_c( C.User_Name.all );
	    pass : char_array := to_c( C.User_Password.all );
	    dbname : char_array := to_c( C.DB_Name.all );
	 begin
	    C.Connected := mysql_connect(
				  conn 	=> C.Connection,  -- Connection object
				  host	=> host'Address ,        -- host or IP #
				  user	=> user'Address ,       -- user name
				  passwd => pass'Address ,         -- password
				  db	=> dbname'Address ,      -- database
				  port	=> port ,        -- IP Port # or zero
				  local_socket  => system.Null_Address    -- UNIX socket name or null
				 )   /= 0;
	 end;
      elsif c.Port_Format = UNIX_port then
	 declare
	    host : char_array := to_c( C.Host_Name.all );
	    port : char_array := to_c( C.Port_Name.all );
	    user : char_array := to_c( C.User_Name.all );
	    pass : char_array := to_c( C.User_Password.all );
	    dbname : char_array := to_c( C.DB_Name.all );
	 begin
	    C.Connected := mysql_connect(
				  conn 	=> C.Connection,  -- Connection object
				  host	=> host'Address ,        -- host or IP #
				  user	=> user'Address ,       -- user name
				  passwd => pass'Address ,         -- password
				  db	=> dbname'Address ,      -- database
				  port	=> 0 ,        -- IP Port # or zero
				  local_socket  => port'Address    -- UNIX socket name or null
				 )   /= 0;
	 end;
      else
	 raise Program_Error;
	 return;
      end if;

      if not C.Connected then
	 Post_Error(C);
	 Raise_Exception(Not_Connected'Identity,
		  "MY10: Failed to connect to database server (Connect).");
      else
	 declare
	    Host_Name : String := To_Ada(Value(mysql_get_host_name(C.Connection)));
	 begin
	    Replace_String(C.Host_Name,Host_Name);
	 end;

	 declare
	    UNIX_Socket : String := To_Ada(Value(mysql_unix_socket(C.Connection)));
	 begin
	    if UNIX_Socket /= "" then
	       C.Port_Format := UNIX_Port;
	       Replace_String(C.Port_Name,UNIX_Socket);
	       -- Update socket pathname
	    else
	       C.Port_Format := IP_Port;
	       C.Port_Number := mysql_port(C.Connection);
	       -- Update port number used
	       if C.Port_Name /= null then
		  Free(C.Port_Name);
	       end if;
	    end if;
	 end;
      end if;
   end Connect;
   ----------------------------------------
   procedure Set_ssl(C1 : in out MYSQL; key,cert,ca,capath,cipher : String := "" ) is

   use Interfaces.C;
      c_key    : char_array  := to_c( key );
      a_key : system.Address := system.Null_Address;

      c_cert   : char_array  := to_c( cert );
      a_cert   : system.Address := system.Null_Address;

      c_ca     : char_array  := to_c( ca );
      a_ca   : system.Address := system.Null_Address;

      c_capath : char_array  := to_c( capath );
      a_capath   : system.Address := system.Null_Address;

      c_cipher : char_array  := to_c( cipher );
      a_cipher   : system.Address := system.Null_Address;
   begin
      if key /= "" then
         a_key := c_key'Address;
      end if;
      if  cert /= "" then
         a_cert := c_cert'address;
      end if;
      if  ca /= "" then
         a_ca := c_ca'address;
      end if;
      if  capath /= "" then
         a_capath := c_capath'address;
      end if;
      if  cipher /= "" then
         a_cipher := c_cipher'address;
      end if;

      my_set_ssl(C1 , a_key, a_cert , a_ca , a_capath , a_cipher );

   end Set_ssl;
   -----------------------------------------
   procedure Connect_ssl(C : in out Connection_Type;
                         key,cert,ca,capath,cipher : String := "" ;
                         Check_Connection : Boolean := True )
   is
   begin
      Raise_Exception(Not_Supported'Identity,
		      "MY01: MySQL, Connect_ssl() is obsolete. use add_key_nameval() (Connect_ssl).");
   end Connect_ssl;

      --------------------------
--  	procedure Connect_old(C : in out Connection_Type; Same_As : Root_Connection_Type'Class) is
--  		type Info_Func is access function(C : Connection_Type) return String;
--
--  		procedure Clone(S : in out String_Ptr; Get_Info : Info_Func) is
--  			Info : String := Get_Info(Connection_Type(Same_As));
--  		begin
--  			if Info'Length > 0 then
--  				S     := new String(1..Info'Length);
--  				S.all := Info;
--  			else
--  				null;
--  				pragma assert(S = null);
--  			end if;
--  		end Clone;
--
--  	begin
--  		Reset(C);
--
--  		C.SQL_Case := Same_As.SQL_Case;
--
--  		Clone(C.Host_Name,Host_Name'Access);
--
--  		C.Port_Format := Same_As.Port_Format;
--  		if C.Port_Format = IP_Port then
--  			C.Port_Number := Port(Same_As);     -- IP_Port
--  		else
--  			Clone(C.Port_Name,Port'Access);     -- UNIX_Port
--  		end if;
--
--  		Clone(C.DB_Name,DB_Name'Access);
--  		Clone(C.User_Name,User'Access);
--  		Clone(C.User_Password,Password'Access);
--  		Clone(C.Options,Options'Access);
--
--  		C.Rollback_Finalize  := Same_As.Rollback_Finalize;
--
--  		Connect(C);	-- Connect to database before worrying about trace facilities
--
--  		-- TRACE FILE & TRACE SETTINGS ARE NOT CLONED
--
--  	end Connect_old;
   procedure Connect(C : in out Connection_Type; Same_As : Root_Connection_Type'Class) is

      type Info_Func is access function(C : Connection_Type) return String;

      procedure Clone(S : in out String_Ptr; Get_Info : Info_Func) is
	 Info : String := Get_Info(Connection_Type(Same_As));
      begin
	 if Info'Length > 0 then
	    S     := new String(1..Info'Length);
	    S.all := Info;
	 else
	    null;
	    pragma assert(S = null);
	 end if;
      end Clone;

   begin
      Reset(C);

      C.SQL_Case := Same_As.SQL_Case;

      Clone(C.Host_Name,Host_Name'Access);

      C.Port_Format := Same_As.Port_Format;
      if C.Port_Format = IP_Port then
	 C.Port_Number := Port(Same_As);     -- IP_Port
      else
	 Clone(C.Port_Name,Port'Access);     -- UNIX_Port
      end if;

      Clone(C.DB_Name,DB_Name'Access);
      Clone(C.User_Name,User'Access);
      Clone(C.User_Password,Password'Access);
      --Clone(C.Options,Options'Access);

      C.Rollback_Finalize  := Same_As.Rollback_Finalize;
      -- I believe if "Same_As" var is defacto a "Connection_Type" as "C" var,
      -- there are need for copy  key's name and val from "Same_As" ,
      -- because in this keys and vals
      -- maybe are key's how sslmode , gsspi etc, that are defacto needs for connecting "C"

      if Same_As.Engine_Of = Engine_MySQL then
         clone_clone_my(C , Connection_Type(Same_as));
      end if;

     connect(C);-- Connect to database before worrying about trace facilities

      -- TRACE FILE & TRACE SETTINGS ARE NOT CLONED

   end Connect;


	procedure Disconnect(C : in out Connection_Type) is
	begin
		if C.Connection /= Null_Connection then
			C.Connection := mysql_close(C.Connection);
			C.Connection := Null_Connection;
		end if;

		C.Connected := False;
	end Disconnect;



	function Is_Connected(C : Connection_Type) return Boolean is
	begin
		if C.Connection /= Null_Connection and then C.Connected then
			return mysql_is_connected( C.Connection ) = 1;
		else
			return False;
		end if;
	end Is_Connected;



	procedure Internal_Reset(C : in out Connection_Type; In_Finalize : Boolean := False) is
	begin
		Free_Ptr(C.Error_Message);

		if C.Connection /= Null_Connection then
		-- Abort query, and rollback..
			declare
				Q : Query_Type;
			begin
				Clear_Abort_State(C);

				if C.Rollback_Finalize or In_Abort_State(C) then
					if C.Trace_On and then
						C.Trace_Filename /= null and then
						In_Finalize = True then

						Ada.Text_IO.Put_Line(C.Trace_Ada,
						"-- ROLLBACK ON FINALIZE");
					end if;

					Rollback_Work(Q,C);
				else
					if C.Trace_On and then
						C.Trace_Filename /= null and then
						In_Finalize = True then

						Ada.Text_IO.Put_Line(C.Trace_Ada,
						"-- COMMIT ON FINALIZE");
					end if;

					Commit_Work(Q,C);
				end if;
			exception
				when others =>
					null;       -- Ignore if the Rollback/commit fails
			end;

			Clear_Abort_State(C);
			Disconnect(C);

			if C.Trace_Filename /= null then
				Close_DB_Trace(C);
			end if;

		end if;

		if In_Finalize then
			Free_Ptr(C.Host_Name);
			Free_Ptr(C.Host_Address);
			Free_Ptr(C.DB_Name);
			Free_Ptr(C.User_Name);
			Free_Ptr(C.User_Password);
			Free_Ptr(C.Error_Message);
		end if;

	end Internal_Reset;


	procedure Reset(C : in out Connection_Type) is
	begin
		Internal_Reset(C,False);
	end Reset;


	function Error_Message(C : Connection_Type) return String is
	begin
		if C.Error_Message /= null then
			return C.Error_Message.all;
		else
			return "";
		end if;
	end Error_Message;


	procedure Open_DB_Trace(C : in out Connection_Type;
		Filename : String; Mode : Trace_Mode_Type := Trace_APQ) is
	begin
		if C.Trace_Filename /= null then
			Raise_Exception(Tracing_State'Identity,
				"MY28: Object already in trace mode (Open_DB_Trace).");
		end if;

		if not Is_Connected(C) then
			Raise_Exception(Not_Connected'Identity,
				"MY29: Unconnected connection object (Open_DB_Trace).");
		end if;

		if Mode = Trace_None then
			pragma assert(C.Trace_Mode = Trace_None);
			return;     -- No trace required
		end if;

		Ada.Text_IO.Create(C.Trace_Ada,Append_File,Filename,Form => "shared=yes");
		C.Trace_File := CStr.Null_Stream;      -- Not used for MySQL

		Ada.Text_IO.Put_Line(C.Trace_Ada,
			"-- Start of Trace, Mode = " & Trace_Mode_Type'Image(Mode));

		C.Trace_Filename     := new String(1..Filename'Length);
		C.Trace_Filename.all := Filename;
		C.Trace_Mode         := Mode;
		C.Trace_On           := True;          -- Enabled by default until Set_Trace disables this
	end Open_DB_Trace;



	procedure Close_DB_Trace(C : in out Connection_Type) is
	begin
		if C.Trace_Mode = Trace_None then
			return;           -- No tracing in progress
		end if;

		pragma assert(C.Trace_Filename /= null);

		Free(C.Trace_Filename);

		Ada.Text_IO.Put_Line(C.Trace_Ada,"-- End of Trace.");
		Ada.Text_IO.Close(C.Trace_Ada);  -- C.Trace_File is not used for MySQL

		C.Trace_Mode := Trace_None;
		C.Trace_On   := True;            -- Restore default
	end Close_DB_Trace;



	procedure Set_Trace(C : in out Connection_Type; Trace_On : Boolean := True) is
		Orig_Trace : Boolean := C.Trace_On;
	begin
		C.Trace_On := Set_Trace.Trace_On;

		if Orig_Trace = C.Trace_On then
			return;        -- No change
		end if;

		if C.Trace_On then
			if C.Trace_Mode = Trace_DB or C.Trace_Mode = Trace_Full then
				null;
			end if;
		else
			if C.Trace_Mode = Trace_DB or C.Trace_Mode = Trace_Full then
				null;
			end if;
		end if;
	end Set_Trace;


	function Is_Trace(C : Connection_Type) return Boolean is
	begin
		return C.Trace_On;
	end Is_Trace;



	function In_Abort_State(C : Connection_Type) return Boolean is
	begin
		if C.Connection = Null_Connection then
			return False;
		end if;

		return C.Abort_State;
	end In_Abort_State;


	-------------------
	-- SQL QUERY API --
	-------------------


	procedure Clear(Q : in out Query_Type) is
	begin
		Clear_Results(Q);
		Clear(Root_Query_Type(Q));
	end Clear;

	procedure Append_Quoted(Q : in out Query_Type;
		Connection : Root_Connection_Type'Class;
		SQL : String; After : String := "") is

		use Interfaces.C;

		C_Length :  size_t := size_t(SQL'Length * 2 + 1);
		C_From :    char_array := To_C(SQL);
		C_To :      char_array(0..C_Length-1);
		R_Length :  u_long := mysql_real_escape_string(
		Connection_Type(Connection).Connection,C_To'Address,C_From'Address,u_long(SQL'Length));
	begin
		Append(Q,"'" & To_Ada(C_To) & "'",After);
		Q.Caseless(Q.Count) := False; -- Do not change case of this text
	end Append_Quoted;



	procedure Execute(Query : in out Query_Type; Connection : in out Root_Connection_Type'Class) is
		R : Return_Status;
	begin

		Query.SQL_Case := Connection.SQL_Case;

		if not Is_Connected(Connection_Type(Connection)) then
			Raise_Exception(Not_Connected'Identity,
				"MY11: Unconnected Connection_Type object (Execute).");
		end if;

		Clear_Results(Query);
		Query.Rewound := True;

		declare
			use Interfaces.C;

			A_Query :   String := To_String(Query);
			C_Query :   char_array := To_C(A_Query);
		begin
			if Connection_Type(Connection).Trace_On then
				if Connection_Type(Connection).Trace_Mode = Trace_APQ
					or Connection_Type(Connection).Trace_Mode = Trace_Full then
						Ada.Text_IO.Put_Line(Connection.Trace_Ada,"-- SQL QUERY:");
						Ada.Text_IO.Put_Line(Connection.Trace_Ada,A_Query);
						Ada.Text_IO.Put_Line(Connection.Trace_Ada,";");
				end if;
			end if;

			R := mysql_query(Connection_Type(Connection).Connection,C_Query'Address);
		end;

		Post_Error(Query,Connection_Type(Connection));

		if R /= 0 then
			-- Successful
			Query.Tuple_Index := Tuple_Index_Type'First;
			Query.Row_ID := Row_ID_Type(mysql_insert_id(
				Connection_Type(Connection).Connection));

			case Query.Mode is
				when Sequential_Fetch =>
					Query.Results := mysql_use_result(
						Connection_Type(Connection).Connection);
				when Random_Fetch =>
					Query.Results := mysql_store_result(
					Connection_Type(Connection).Connection);
				when Cursor_For_Update | Cursor_For_Read_Only =>
					Raise_Exception(Not_Supported'Identity,
						"MY12: MySQL does not support Cursor fetch modes (Execute).");
				end case;

			if Query.Results = Null_Result then
				if mysql_field_count(Connection_Type(Connection).Connection) /= 0 then
					-- The query should return data, hence an error :
					Post_Error(Query,Connection_Type(Connection));

					if Connection.Trace_On then
						Ada.Text_IO.Put_Line(Connection_Type(Connection).Trace_Ada,"-- Error " &
							Result_Type'Image(Query.Error_Code) & " : " & Error_Message(Query));
						Ada.Text_IO.New_Line(Connection_Type(Connection).Trace_Ada);
					end if;

					Raise_Exception(SQL_Error'Identity,
						"MY13: Query failed (Execute).");
				else
					if Connection_Type(Connection).Trace_On then
						Ada.Text_IO.New_Line(Connection_Type(Connection).Trace_Ada);
					end if;
				end if;
			else
				-- We received a result :
				if Connection.Trace_On then
					if Connection_Type(Connection).Trace_Mode = Trace_APQ
						or Connection_Type(Connection).Trace_Mode = Trace_Full then

						Ada.Text_IO.New_Line(Connection_Type(Connection).Trace_Ada);
					end if;
				end if;
			end if;
		else
		-- Query failed :
			if Connection_Type(Connection).Trace_On then
				Ada.Text_IO.Put_Line(Connection_Type(Connection).Trace_Ada,"-- Error " &
					Result_Type'Image(Query.Error_Code) & " : " & Error_Message(Query));
				Ada.Text_IO.New_Line(Connection_Type(Connection).Trace_Ada);
			end if;

			Raise_Exception(SQL_Error'Identity,
				"MY13: Query failed to execute (Execute) :: """ &
					To_String( Query ) & """"
				);
		end if;

	end Execute;

	procedure Execute_Checked(Query : in out Query_Type;
		Connection : in out Root_Connection_Type'Class; Msg : String := "") is

		use Ada.Text_IO;
	begin
		begin
			Execute(Query,Connection);
		exception
			when Ex : SQL_Error =>

			if Msg'Length > 0 then
				Put(Standard_Error,"*** SQL ERROR: ");
				Put_Line(Standard_Error,Msg);
			else

			Put(Standard_Error,"*** SQL ERROR IN QUERY:");
			New_Line(Standard_Error);
			Put(Standard_Error,To_String(Query));

			if Col(Standard_Error) > 1 then
				New_Line(Standard_Error);
			end if;
		end if;

		Put(Standard_Error,"[");
		Put(Standard_Error,Result_Type'Image(Result(Query)));
		Put(Standard_Error,": ");
		Put(Standard_Error,Error_Message(Query));
		Put_Line(Standard_Error,"]");
		Reraise_Occurrence(Ex);

		when Ex : others =>
			Reraise_Occurrence(Ex);
		end;
	end Execute_Checked;



	procedure Begin_Work(Query : in out Query_Type;
		Connection : in out Root_Connection_Type'Class) is
	begin
		Clear(Query);
		Prepare(Query,"BEGIN WORK");
		Execute(Query,Connection_Type(Connection));
		Clear(Query);
	end Begin_Work;


	procedure Commit_Work(Query : in out Query_Type;
		Connection : in out Root_Connection_Type'Class) is
	begin
		Clear(Query);
		Prepare(Query,"COMMIT");
		Execute(Query,Connection_Type(Connection));
		Clear(Query);
	end Commit_Work;


	procedure Rollback_Work(Query : in out Query_Type;
		Connection : in out Root_Connection_Type'Class) is
	begin
		Clear(Query);
		Prepare(Query,"ROLLBACK");
		Execute(Query,Connection_Type(Connection));
		Clear(Query);
	end Rollback_Work;


	procedure Rewind(Q : in out Query_Type) is
	begin
		Q.Row := Null_Row;

		case Q.Mode is
			when Random_Fetch =>
				Q.Rewound := True;
				Q.Tuple_Index := First_Tuple_Index;
			when Sequential_Fetch =>
				Raise_Exception(SQL_Error'Identity,
					"MY17: Cannot rewind a Sequential_Fetch mode query (Rewind).");
			when Cursor_For_Update | Cursor_For_Read_Only =>
				Raise_Exception(Not_Supported'Identity,
					"MY18: Cursors are not supported by MySQL client library (Rewind).");
		end case;
	end Rewind;


	procedure Fetch(Q : in out Query_Type) is
	begin
		if not Q.Rewound then
			Q.Tuple_Index := Q.Tuple_Index + 1;
		else
			Q.Rewound := False;
			Q.Tuple_Index := First_Tuple_Index;
		end if;

		case Q.Mode is
			when Random_Fetch =>
				Fetch(Q,Q.Tuple_Index);

			when Sequential_Fetch =>
				Q.Row := mysql_fetch_row(Q.Results);
				Post_Error(Q);

				if Q.Row = Null_Row then
					Raise_Exception(No_Tuple'Identity,
						"MY19: There are no more row results to be fetched (Fetch).");
				end if;

			when Cursor_For_Update | Cursor_For_Read_Only =>
				Raise_Exception(Not_Supported'Identity,
					"MY20: Cursors are not supported by the MySQL client library (Fetch).");
		end case;
	end Fetch;

	procedure Fetch(Q : in out Query_Type; TX : Tuple_Index_Type) is
		Row_No : MYSQL_ROW_NO := MYSQL_ROW_NO(TX);
	begin
		Q.Row := Null_Row;

		if TX < 1 then
			Raise_Exception(No_Tuple'Identity,
				"MY21: There are no more row results to be fetched (Fetch).");
		end if;

		if Q.Mode = Random_Fetch then
			declare
				X : MYSQL_ROW_NO := Row_No - 1;
				R : MYSQL_ROW;
			begin
				R := mysql_fetch_row_direct(Q.Results,X);
				Q.Row := R;
			end;

			Post_Error(Q);

			if Q.Row = Null_Row then
				Raise_Exception(No_Tuple'Identity,
					"MY22: There are no more row results to be fetched (Fetch).");
			end if;
		else
			Q.Row := Null_Row;   -- Don't try to reference this row later, if any
			Raise_Exception(Failed'Identity,
				"MY23: This query mode does not support random row fetches (Fetch).");
		end if;
   end Fetch;



	function End_of_Query(Q : Query_Type) return Boolean is
		use Interfaces.C;

		NT : Tuple_Count_Type := Tuples(Q); -- May raise No_Result

	begin
		case Q.Mode is
			when Random_Fetch =>
				if NT < 1 then
					return True;      -- There are no tuples to return
				end if;

				if Q.Rewound then
					return False;     -- There is at least 1 tuple to return yet
				end if;

				return Tuple_Count_Type(Q.Tuple_Index) >= NT;   -- We've fetched them all
			when Sequential_Fetch =>

				-- *** MySQL Limitation ***
				--
				--    For sequential fetches, you _MUST_ catch the
				-- exception No_Tuple while doing a FETCH, to determine
				-- where the last row is. MySQL C function mysql_eof()
				-- returns True, until an attempt to fetch the last row
				-- occurs (thus is of no value in preventing the bad
				-- fetch!)
				--
				-- End_Of_Query is a function, so it cannot prefetch either.
				-- Sooooo.. we just raise a Program_Error.

				Raise_Exception(Program_Error'Identity,
					"MY25: End_of_Query is not usable in MySQL (End_of_Query).");
					--          return mysql_eof(Q.Results) /= 0;

			when Cursor_For_Update | Cursor_For_Read_Only =>
				Raise_Exception(Not_Supported'Identity,
					"MY26: Cursors are not supported in the MySQL client library (End_of_Query).");
		end case;
	end End_of_Query;


	function Tuple(Q : Query_Type) return Tuple_Index_Type is
		NT : Tuple_Count_Type := Tuples(Q); -- May raise No_Result
	begin
		if NT < 1 or else Q.Rewound then
			Raise_Exception(No_Tuple'Identity,
				"MY24: There are no more row results to be fetched (Tuple).");
		end if;

		return Q.Tuple_Index;
	end Tuple;

	function Tuples(Q : Query_Type) return Tuple_Count_Type is
		begin
			if Q.Results = Null_Result then
				Raise_Exception(No_Result'Identity,
					"MY27: There are no results (Tuples).");
			end if;

			return Tuple_Count_Type(mysql_num_rows(Q.Results));
	end Tuples;



	function Columns(Q : Query_Type) return Natural is
	begin
		if Q.Results = Null_Result then
			Raise_Exception(No_Result'Identity,
				"MY30: There are no results (Columns).");
		end if;

		return Natural(mysql_num_fields(Q.Results));
	end Columns;



	function Column_Name(Q : Query_Type; CX : Column_Index_Type) return String is
		use Interfaces.C;

		CBX :    int := int(CX) - 1;     -- Make zero based
		Cols :   Natural := 0;           -- # of columns in result
	begin
		if Q.Results = Null_Result then
			Raise_Exception(No_Result'Identity,
				"MY31: There are no results (Column_Name).");
		end if;

		-- We must check index, since mysql_fetch_field_direct() won't
		if not Is_Column(Q,CX) then
			Raise_Exception(No_Column'Identity,
				"MY32: There is no column #" &
				Column_Index_Type'Image(CX) &
				" (Column_Name).");
		end if;

		declare
			use Interfaces.C.Strings;
			cp : chars_ptr := mysql_field_name(mysql_fetch_field_direct(Q.Results,CBX));
		begin
			if CP = Null_Ptr then
				Raise_Exception(No_Column'Identity,
					"MY33: MySQL client library does not know about the column #"
					& Column_Index_Type'Image(CX) & " (Column_Name).");
			end if;

			return To_Case(Value_Of(CP),Q.SQL_Case);
		end;
	end Column_Name;



	function Column_Index(Q : Query_Type; Name : String) return Column_Index_Type is
		use Interfaces.C;

		C_Name :    char_array := To_C(Name);
		CBX :       int := -1;
	begin
		if Q.Results = Null_Result then
			Raise_Exception(No_Result'Identity,
				"MY34: There are no resuls (Column_Index).");
		end if;

		CBX := mysql_name_index(Q.Results,C_Name'Address);
		if CBX < 0 then
			Raise_Exception(No_Column'Identity,
				"MY35: There is no column named '" & Name & "' (Column_Index).");
		end if;

		return Column_Index_Type(CBX+1);
	end Column_Index;



	function Column_Type(Q : Query_Type; CX : Column_Index_Type) return Field_Type is
		use Interfaces.C;

		CBX : int := int(CX) - 1;
	begin
		if Q.Results = Null_Result then
			Raise_Exception(No_Result'Identity,
				"MY38: There are not results (Column_Type).");
		end if;

		if not Is_Column(Q,CX) then
			Raise_Exception(No_Column'Identity,
				"MY39: There is no column #" &
				Column_Index_Type'Image(CX) &
				" (Column_Type).");
		end if;

		return mysql_get_field_type(Q.Results,CBX);
	end Column_Type;


	function Is_Null(Q : Query_Type; CX : Column_Index_Type) return Boolean is
	begin
		if Q.Results = Null_Result then
			Raise_Exception(No_Result'Identity,
				"MY36: There are no column results (Is_Null).");
		end if;

		if not Is_Column(Q,CX) then
			Raise_Exception(No_Column'Identity,
			"MY37: There is no column #" & Column_Index_Type'Image(CX) & " (Is_Null).");
		end if;

		declare
			use Interfaces.C.Strings;

			Col_Val : chars_ptr := Value_Of(Q.Results,Q.Row,CX);
		begin
			return Is_Null(Col_Val);
		end;
	end Is_Null;


	function Value(Query : Query_Type; CX : Column_Index_Type) return String is
	begin
		if not Is_Column(Query,CX) then
			Raise_Exception(No_Column'Identity, "MY14: There is no column #" &
				Column_Index_Type'Image(CX) &" (Value).");
		end if;

		if Query.Row = Null_Row then
			Raise_Exception(No_Result'Identity,
			"MY15: There are no column results (Value).");
		end if;

		declare
			use Interfaces.C.Strings;

			Col_Val : chars_ptr := Value_Of(Query.Results,Query.Row,CX);
		begin
			if Is_Null(Col_Val) then
				Raise_Exception(Null_Value'Identity,
					"MY16: Column" & Column_Index_Type'Image(CX) &
					" is NULL (Value).");
			else
				return Value_Of(Col_Val);
			end if;
		end;
	end Value;


	function Result(Query : Query_Type) return Natural is
	begin
		return Result_Type'Pos(Result(Query));
	end Result;


	function Result(Query : Query_Type) return Result_Type is
	begin
		return Query.Error_Code;
	end Result;


	function Command_Oid(Query : Query_Type) return Row_ID_Type is
	begin
		return Query.Row_ID;
	end Command_Oid;


	function Null_Oid return Row_ID_Type is
	begin
		return Null_Row_ID;
	end Null_Oid;

	function Null_Oid(Query : Query_Type) return Row_ID_Type is
	begin
		return Null_Row_ID;
	end Null_Oid;


	function Error_Message(Query : Query_Type) return String is
	begin
		return To_String(Query.Error_Message);
	end Error_Message;


	function Is_Duplicate_Key(Query : Query_Type) return Boolean is
	R : Result_Type := Result(Query);
	begin
	return R = ER_DUP_ENTRY or else R = ER_DUP_KEY;
	end Is_Duplicate_Key;


	function Engine_Of(Q : Query_Type) return Database_Type is
	begin
	return Engine_MySQL;
	end Engine_Of;



	procedure Initialize(C : in out Connection_Type) is
	begin
		C.Connection := mysql_init;
		C.Connected  := False;
		C.SQL_Case   := Lower_Case;
	end Initialize;


	procedure Initialize(Q : in out Query_Type) is
	begin
		Q.SQL_Case := Lower_Case;
	end Initialize;


	procedure Adjust(Q : in out Query_Type) is
	begin
		Q.Results := Null_Result;
		Q.Row     := Null_Row;
		Q.Error_Message := null;
		Q.Row_ID  := Row_ID_Type'First;
		Adjust(Root_Query_Type(Q));
	end Adjust;


	procedure Finalize(C : in out Connection_Type) is
	begin
		Internal_Reset(C,True);
	end Finalize;


	procedure Finalize(Q : in out Query_Type) is
	begin
		Clear(Q);
	end Finalize;




	procedure Set_Fetch_Mode(Q : in out Query_Type; Mode : Fetch_Mode_Type) is
	begin
		if Q.Results /= Null_Result then
			Raise_Exception(Failed'Identity,
				"MY40: Cannot change fetch mode when results exist (Set_Fetch_Mode).");
		end if;

		Set_Fetch_Mode(Root_Query_Type(Q),Mode);
	end Set_Fetch_Mode;


	function Query_Factory( C: in Connection_Type )
		return Root_Query_Type'Class is
		q: query_type;
	begin
		return q;
	end query_factory;


	function SQL_Code(Query : Query_Type) return SQL_Code_Type is
	begin
		return 0;
	end sql_code;

begin
	my_init;
end APQ.MySQL.Client;

