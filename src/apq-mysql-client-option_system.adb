


package body apq.mysql.Client.option_system is

   function is_valid( val : string ) return nature_enum_type
   is
      use ada.Strings.Fixed;
   begin
      declare
	 val_tmp : string := trim(val,ada.Strings.Both);
	 mi_hold : nature_enum_type := none;
      begin
	 if val_tmp = "" then
	    return nature_enum_type'(none);
	 end if;
	 mi_hold := nature_enum_type'(nature_enum_type'value(val_tmp));
	 return mi_hold;
      exception
	 when others => null ;
      end;
      return nature_enum_type'(none);
   end is_valid;

   function is_valid( val : string_ptr ) return nature_enum_type
   is
   begin
      if val = null then
	 return nature_enum_type'(none);
      end if;
      return nature_enum_type'(is_valid(val.all));
   end is_valid;

   function is_valid( val : string;  into: nature_enum_type ) return boolean
   is
   begin
      return ( nature_enum_type'(is_valid(val))) /= nature_enum_type'(none) ;
   end is_valid;

   function is_valid( val : string_ptr;  into: nature_enum_type ) return boolean
   is
   begin
      return ( nature_enum_type'(is_valid(val))) /= nature_enum_type'(none) ;
   end is_valid;
   -----
   -----
   procedure get_nature_enum(
			     val : in string;
			     net : out nature_enum_type;
			     is_valid : out boolean
			    )
   is
      mi_hold : nature_enum_type := nature_enum_type'(is_valid(val));
   begin
      is_valid := ( mi_hold /= nature_enum_type'(none) );
      net := mi_hold;
   end get_nature_enum;

   procedure get_nature_enum(
			     val : in string_ptr;
			     net : out nature_enum_type;
			     is_valid : out boolean
			    )
   is
      mi_hold : nature_enum_type := nature_enum_type'(is_valid(val));
   begin
      is_valid := ( mi_hold /= nature_enum_type'(none) );
      net := mi_hold;
   end get_nature_enum;

   ----
   ----
   ----
   ----
   function is_valid( val : string ) return root_option_enum
   is
      use ada.Strings.Fixed;
   begin
      declare
	 val_tmp : string := trim(val,ada.Strings.Both);
	 mi_hold : root_option_enum := none;
      begin
	 if val_tmp = "" then
	    return root_option_enum'(none);
	 end if;
	 mi_hold := root_option_enum'(root_option_enum'value(val_tmp));
	 return mi_hold;
      exception
	 when others => null;
      end;
      return root_option_enum'(none);
   end is_valid;

   function is_valid( val : string_ptr ) return root_option_enum
   is
   begin
      if val = null then
	 return root_option_enum'(none);
      end if;
      return root_option_enum'(is_valid(val.all));
   end is_valid;

   function is_valid( val : string;  into: root_option_enum ) return boolean
   is
   begin
      return (root_option_enum'(is_valid(val))) /= root_option_enum'(none) ;
   end is_valid;

   function is_valid( val : string_ptr;  into: root_option_enum ) return boolean
   is
   begin
      return (root_option_enum'(is_valid(val))) /= root_option_enum'(none) ;
   end is_valid;
   ----
   ----
   procedure get_root_option_enum(
				  val : in string;
				  roe : out root_option_enum;
				  is_valid : out boolean
				 )
   is
      mi_hold : root_option_enum := root_option_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= root_option_enum'(none));
      roe := mi_hold;
   end get_root_option_enum;

   procedure get_root_option_enum(
				  val : in string_ptr;
				  roe : out root_option_enum;
				  is_valid : out boolean
				 )
   is
      mi_hold : root_option_enum := root_option_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= root_option_enum'(none));
      roe := mi_hold;
   end get_root_option_enum;
   ----
   ----
   ----
   ----
   function is_valid( val : string ) return common_enum
   is
      use ada.Strings.Fixed;
   begin
      declare
	 val_tmp : string := trim(val,ada.Strings.Both);
	 mi_hold : common_enum := none;
      begin
	 if val_tmp = "" then
	    return common_enum'(none);
	 end if;
	 mi_hold := common_enum'(common_enum'value(val_tmp));
	 return mi_hold;
      exception
	 when others => null;
      end;
      return common_enum'(none);
   end is_valid;

   function is_valid( val : string_ptr ) return common_enum
   is
   begin
      if val = null then
	 return common_enum'(none);
      end if;
      return common_enum'(is_valid(val.all));
   end is_valid;

   function is_valid( val : string;  into: common_enum ) return boolean
   is
   begin
      return (common_enum'(is_valid(val))) /= common_enum'(none);
   end is_valid;

   function is_valid( val : string_ptr;  into: common_enum ) return boolean
   is
   begin
      return (common_enum'(is_valid(val))) /= common_enum'(none);
   end is_valid;
   ----
   ----
   procedure get_common_enum(
			     val : in string;
			     gce : out common_enum;
			     is_valid : out boolean
			    )
   is
      mi_hol : common_enum := common_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= common_enum'(none));
      gce := mi_hold;
   end get_common_enum;

   procedure get_common_enum(
			     val : in string_ptr;
			     gce : out common_enum;
			     is_valid : out boolean
			    )
   is
      mi_hol : common_enum := common_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= common_enum'(none));
      gce := mi_hold;
   end get_common_enum;
   ----
   ----
   ----
   ----
   function is_valid( val : string ) return ssl_enum
   is
      use ada.Strings.Fixed;
   begin
      declare
	 val_tmp : string := trim(val,ada.Strings.Both);
	 mi_hold : ssl_enum := none;
      begin
	 if val_tmp = "" then
	    return ssl_enum'(none);
	 end if;
	 mi_hold := ssl_enum'(ssl_enum'value(val_tmp));
	 return mi_hold;
      exception
	 when others => null;
      end;
      return ssl_enum'(none);
   end is_valid;

   function is_valid( val : string_ptr ) return ssl_enum
   is
   begin
      if val = null then
	 return ssl_enum'(none);
      end if;
      return ssl_enum'(is_valid(val.all));
   end is_valid;

   function is_valid( val : string;  into: ssl_enum ) return boolean
   is
   begin
      return (ssl_enum'(is_valid(val))) /= ssl_enum'(none);
   end is_valid;

   function is_valid( val : string_ptr;  into: ssl_enum ) return boolean
   is
   begin
      return (ssl_enum'(is_valid(val))) /= ssl_enum'(none);
   end is_valid;
   ----
   ----
   procedure get_ssl_enum(
			  val : in string;
			  gse : out ssl_enum;
			  is_valid : out boolean
			 )
   is
      mi_hold : ssl_enum := ssl_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= ssl_enum'(none));
      gse := mi_hold;
   end get_ssl_enum;

   procedure get_ssl_enum(
			  val : in string_ptr;
			  gse : out ssl_enum;
			  is_valid : out boolean
			 )
   is
      mi_hold : ssl_enum := ssl_enum'(is_valid(val));
   begin
      is_valid := ( mi_hold /= ssl_enum'(none));
      gse := mi_hold;
   end get_ssl_enum;
   ----
   ----
   ----
   ----
   function "="(Left  => root_option_record ,
		Right => root_option_record) return boolean
   is
   begin
      if left.especie /= Right.especie then
	 return false;
      end if;
      if left.especie = none then
	 return true;
      end if;
      if left.especie = ssl then
	 return ( left.key_ssl = right.key_ssl ) ;
      end if;
      if left.especie = common then
	 return ( left.key_common = right.key_common );
      end if;

      raise Program_Error; -- if have more especies of key, added here the logic :-)
      return false; -- stub
   end "=";

   procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname, kval : in string := "";
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			    )
   is
   begin
      add_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end add_keyname_val;

   procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string := "";
			     kval : in string_ptr := null;
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			    )
   is
   begin
      add_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end add_keyname_val;

    procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string_ptr := null;
			     kval : in string_ptr := null;
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			     )
   is
   begin
      add_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end add_keyname_val;

    procedure add_keyname_val(
			     kclass : in out root_option_record'Class ;
			     kname  : in string_ptr := null;
			     kval : in string := "";
			     kval_nature : in nature_enum_type := none;
			     is_valid : in out boolean
			     )
   is
   begin
      add_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end add_keyname_val;

   procedure get_keyname_val(
			     kclass : in root_option_record'Class ;
			     kname, kval : in out string_ptr ;
			     kval_nature : in out nature_enum_type;
			     is_valid : in out boolean
			    )
   is
   begin
      get_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end get_keyname_val;

   procedure get_keyname_val(
			     kclass : in root_option_record'Class ;
			     kname  : in out string_ptr ;
			     kval   : in out unsigned_integer;
			     kval_nature : in out nature_enum_type;
			     is_valid : in out boolean
			    )
   is
   begin
      get_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end get_keyname_val;

   procedure get_keyname_val(
			     kclass : in root_option_record'Class ;
			     kname  : in out string_ptr ;
			     kval   : in out unsigned_integer_ptr;
			     kval_nature : in out nature_enum_type;
			     is_valid : in out boolean
			    )
   is
   begin
      get_keyname_val(kclass, kname, kval , kval_nature, is_valid );
   end get_keyname_val;

   type root_option_record_ptr is access all root_option_record'class ;
   -- return 'null' when invalid string :-)
   function is_valid( val : string; into : root_option_record'class ) return root_option_record'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string; into : root_option_record'class ) return root_option_record_ptr'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string; into: root_option_record_ptr'class ) return root_option_record'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string; into: root_option_record_ptr'class ) return root_option_record_ptr'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record'class ) return root_option_record'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record'class ) return root_option_record_ptr'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record_ptr'class ) return root_option_record'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record_ptr'class ) return root_option_record_ptr'class
   is
   begin
      return is_valid(val,into);
   end is_valid;

   function is_valid( val : string; into: root_option_record'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val,into));
   end is_valid;

   function is_valid( val : string; into: root_option_record_ptr'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val,into));
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val,into));
   end is_valid;

   function is_valid( val : string_ptr; into: root_option_record_ptr'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val,into));
   end is_valid;

   function is_valid( val : root_option_record'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val));
   end is_valid;

   function is_valid( val : root_option_record_ptr'class ) return boolean
   is
   begin
      return Boolean'(is_valid(val));
   end is_valid;
   ----
   ----
   ----
   ----







end apq.mysql.client.option_system;
