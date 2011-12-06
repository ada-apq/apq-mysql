
with Ada.Containers.Doubly_Linked_Lists;


package apq.mysql.client.option_system is

   type nature_enum_type is ( nat_ptr_char, nat_ptr_ui, nat_uint,
			     nat_not_used, nat_ptr_my_bool, none );
   function is_valid( val : string ) return nature_enum_type;
   function is_valid( val : string_ptr ) return nature_enum_type;
   function is_valid( val : string;  into: nature_enum_type ) return boolean ;
   function is_valid( val : string_ptr;  into: nature_enum_type ) return boolean;
   procedure get_nature_enum(
			     val : in string;
			     net : out nature_enum_type;
			     is_valid : out boolean
			    );
   procedure get_nature_enum(
			     val : in string_ptr;
			     net : out nature_enum_type;
			     is_valid : out boolean
			    );
   -----
   type root_option_enum is ( common, ssl, none );
   function is_valid( val : string ) return root_option_enum ;
   function is_valid( val : string_ptr ) return root_option_enum ;
   function is_valid( val : string;  into: root_option_enum ) return boolean ;
   function is_valid( val : string_ptr;  into: root_option_enum ) return boolean;
   procedure get_root_option_enum(
				  val : in string;
				  roe : out root_option_enum;
				  is_valid : out boolean
				 );
   procedure get_root_option_enum(
				  val : in string_ptr;
				  roe : out root_option_enum;
				  is_valid : out boolean
				 );
   -----
   function is_valid( val : string ) return common_enum ;
   function is_valid( val : string_ptr ) return common_enum ;
   function is_valid( val : string;  into: common_enum ) return boolean ;
   function is_valid( val : string_ptr;  into: common_enum ) return boolean;
   procedure get_common_enum(
			     val : in string;
			     gce : out common_enum;
			     is_valid : out boolean
			    );
   procedure get_common_enum(
			     val : in string_ptr;
			     gce : out common_enum;
			     is_valid : out boolean
			    );
   ----
   type ssl_enum is ( key, cert, ca, capath, cipher , none );
   function is_valid( val : string ) return ssl_enum ;
   function is_valid( val : string_ptr ) return ssl_enum ;
   function is_valid( val : string;  into: ssl_enum ) return boolean ;
   function is_valid( val : string_ptr;  into: ssl_enum ) return boolean;
   procedure get_ssl_enum(
			  val : in string;
			  gse : out ssl_enum;
			  is_valid : out boolean
			 );
   procedure get_ssl_enum(
			  val : in string_ptr;
			  gse : out ssl_enum;
			  is_valid : out boolean
			 );
   ---
   type root_option_record is private;
   function "="(Left  => root_option_record ,
		Right => root_option_record) return boolean;
   procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname, kval : in string := "";
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			    );
   procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string := "";
			     kval : in string_ptr := null;
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			    );
    procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string_ptr := null;
			     kval : in string_ptr := null;
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			     );
    procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string_ptr := null;
			     kval : in string := "";
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			    );
   procedure get_keyname_val(
			     kclass : in root_option_record'Class ;
			     kname  : in out string_ptr ;
			     kval   : in out unsigned_integer_ptr;
			     kval_nature : in out nature_enum_type;
			     is_valid : in out boolean
			    );
   package options_list is new Ada.Containers.Doubly_Linked_Lists( root_option_record , "=" );
---

private

   type root_option_record is abstract tagged
      record
	 especie      : root_option_enum := none;
	 is_valid     : boolean := false;
	 value_nature : nature_enum_type := none;
	 --
	 key_ssl : ssl_enum := none;
	 key_common : common_enum := none;
	 --
	 value_s : string_ptr;
	 value_u : Unsigned_Integer := 0 ;
	 value_b : boolean := false;

      end record;





end apq.mysql.client.option_system;
