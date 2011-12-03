


package apq.mysql.client.option_system is

   type nature_enum_type is ( nat_ptr_char, nat_ptr_ui, nat_uint,
			     nat_not_used, nat_ptr_my_bool, none );
   procedure get_nature_enum(
			     val : in string;
			     net : out nature_enum_type;
			     is_valid : out boolean
			    );

   type root_option_enum is ( common, ssl, none );
   procedure get_root_option_enum(
				  val : in string;
				  roe : out root_option_enum;
				  is_valid : out boolean
				 );
   procedure get_common_enum(
			     val : in string;
			     gce : out common_enum;
			     is_valid : out boolean
			    );
   type ssl_enum is ( key, cert, ca, capath, cipher , none );
   procedure get_ssl_enum(
			  val : in string;
			  gse : out ssl_enum;
			  is_valid : out boolean
			 );





   ---
   type root_option_record is abstract tagged
      record
	 especie : root_option_enum := none;
	 is_valid : boolean := false;
	 value_nature : nature_enum_type := none;

      end record;
   procedure add_keyname_val(
			     kclass : root_option_record'Class ;
			     kname, kval : string := "";
			     kval_nature : nature_enum_type := none
			    );
   procedure get_keyname_val(
			     kclass : root_option_record'Class ;
			     kname, kval : out string ;
			     kval_nature : out nature_enum_type
			    );
   ----
   type common_option_record is new root_option_record with
      record
	 key : common_enum ;
	 value : string_ptr ;
	 value_u : unsigned_integer := 0;

      end record;
   procedure add_keyname_val(
			     kclass : common_option_record ;
			     kname, kval : string := "";
			     kval_nature : nature_enum_type := none
			    );
   procedure get_keyname_val(
			     kclass : common_option_record ;
			     kname, kval : out string ;
			     kval_nature : out nature_enum_type
			    );
   ----
   type ssl_option_record is new root_option_record with
      record
	 key : common_enum ;
	 value : string_ptr ;
	 value_u : unsigned_integer := 0;

      end record;
   procedure add_keyname_val(
			     kclass : ssl_option_record ;
			     kname, kval : string := "";
			     kval_nature : nature_enum_type := none
			    );
   procedure get_keyname_val(
			     kclass : ssl_option_record ;
			     kname, kval : out string ;
			     kval_nature : out nature_enum_type
			    );





end apq.mysql.client.option_system;
