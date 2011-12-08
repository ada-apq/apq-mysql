
--  with Ada.Containers.Doubly_Linked_Lists;


package apq.mysql.client.option_system is

--     type nature_enum_type is ( nat_ptr_char, nat_ptr_ui, nat_uint,
--  			     nat_not_used, nat_ptr_my_bool, none );
--     type root_option_enum is ( common, ssl, none );
--     type ssl_enum is ( key, cert, ca, capath, cipher , none );
--     type root_option_record is private;
--     function "="( Left :root_option_record; right : root_option_record) return boolean;
--     package options_list is new Ada.Containers.Doubly_Linked_Lists( root_option_record , "=" );
--
--     procedure add_key_nameval( C : in out Connection_Type;
--  			     kname : ssl_enum ;
--  			     kval : string ;
--  			     clear : boolean := false);
--     --
--     procedure add_key_nameval( C : in out Connection_Type;
--  			     kname : apq.mysql.common_enum;
--  			     kval : string ;
--  			     clear : boolean := false);
--
--     procedure add_key_nameval( C : in out Connection_Type;
--  			     kname : apq.mysql.common_enum;
--  			     kval :  Unsigned_Integer ;
--  			     kval_nature :  nature_enum_type := nature_enum_type'(nat_uint);
--  			     -- nat_uint or nat_ptr_ui
--  			     clear : boolean := false);
--
--     procedure add_key_nameval( C : in out Connection_Type;
--  			     kname : apq.mysql.common_enum;
--  			     clear : boolean := false);
--
--     procedure add_key_nameval( C : in out Connection_Type;
--  			     kname : apq.mysql.common_enum;
--  			     kval :  boolean ;
--  			     clear : boolean := false);

private

--     type root_option_record is tagged
--        record
--  	 especie      : root_option_enum := none;
--  	 is_valid     : boolean := false;
--  	 value_nature : nature_enum_type := none;
--  	 --
--  	 key_ssl : ssl_enum := none;
--  	 key_common : common_enum := none;
--  	 --
--  	 value_s : ada.Strings.Unbounded.Unbounded_String := ada.Strings.Unbounded.To_Unbounded_String("");
--  	 value_u : Unsigned_Integer := 0 ;
--  	 value_b : boolean := false;
--
--        end record;


end apq.mysql.client.option_system;
