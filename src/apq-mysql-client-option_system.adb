


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

   procedure key_nameval( L : in out options_list.list ;
			 val : root_option_record;
			 clear : boolean := false
			)
   is
      use options_list;
      mi_cursor : options_list.cursor := no_element;
   begin
      if clean then
	 if not ( L.is_empty ) then
	    L.clear;
	 end if;
      end if;
      if L.is_empty then
	 L.append(val);
	 return;
      end if;
      mi_cursor := L.find(val);
      if mi_cursor = No_Element then
	 L.append(val);
	 return;
      end if;
      L.replace_element(mi_cursor, val);

   end key_nameval;

   procedure get_keyname_val(
			     kclass : in root_option_record ;
			     kname  : in out string_ptr ;
			     kval   : in out unsigned_integer_ptr;
			     kval_nature : in out nature_enum_type;
			     is_valid : in out boolean
			    );

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : ssl_enum ;
			     kval : string ;
			     clear : boolean := false)
   is
   begin
      if kname = none then
	 return;
      end if;
      declare
	 val_record : root_option_record :=
	   root_option_record'(
			especie => ssl,
			is_valid => true,
			value_nature => nat_ptr_char,
			key_ssl => kname,
			key_common => none,
			value_s => ada.Strings.Unbounded.To_Unbounded_String(kval),
			value_u => 0,
			value_b => false
		       );
      begin
	 key_nameval(
	      L     => c.keyname_val_cache_ssl,
	      val   => val_record,
	      clear => clear );

      end;
   end add_key_nameval;

   --
   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.common_enum;
			     kval : string ;
			     clear : boolean := false)
   is
   begin
      if kname = none then
	 return;
      end if;
      declare
	 val_record : root_option_record :=
	   root_option_record'(
			especie => common ,
			is_valid => true,
			value_nature => nat_ptr_char,
			key_ssl => none ,
			key_common => kname,
			value_s => ada.Strings.Unbounded.To_Unbounded_String(kval),
			value_u => 0,
			value_b => false
		       );
      begin
	 key_nameval(
	      L     => c.keyname_val_cache_common,
	      val   => val_record,
	      clear => clear );

      end;
   end add_key_nameval;

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.common_enum;
			     kval :  Unsigned_Integer ;
			     kval_nature :  nature_enum_type := nature_enum_type'(nat_uint);
			     -- nat_uint or nat_ptr_ui
			     clear : boolean := false)
   is
      kval_tmp : Unsigned_Integer := 1;
   begin
      if kname = none then
	 return;
      end if;
      if not( kval_nature = nat_uint or kval_nature = nat_ptr_ui ) then
	 return;
      end if;
      if kval_nature = nat_ptr_ui then
	 if kval = 0 then
	    kval_tmp = 0;
	 end if;
      else
	 kval_tmp = kval;
      end if;

      declare
	 val_record : root_option_record :=
	   root_option_record'(
			especie => common ,
			is_valid => true,
			value_nature => kval_nature,
			key_ssl => none ,
			key_common => kname,
			value_s => ada.Strings.Unbounded.To_Unbounded_String(""),
			value_u => kval_tmp,
			value_b => false
		       );
      begin
	 key_nameval(
	      L     => c.keyname_val_cache_common,
	      val   => val_record,
	      clear => clear );

      end;
   end add_key_nameval;

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.common_enum;
			     clear : boolean := false)
   is
   begin
      if kname = none then
	 return;
      end if;
      declare
	 val_record : root_option_record :=
	   root_option_record'(
			especie => common ,
			is_valid => true,
			value_nature => nat_not_used,
			key_ssl => none ,
			key_common => kname,
			value_s => ada.Strings.Unbounded.To_Unbounded_String(""),
			value_u => 0,
			value_b => false
		       );
      begin
	 key_nameval(
	      L     => c.keyname_val_cache_common,
	      val   => val_record,
	      clear => clear );

      end;
   end add_key_nameval;

   procedure add_key_nameval( C : in out Connection_Type;
			     kname : apq.mysql.common_enum;
			     kval :  boolean ;
			     clear : boolean := false)
   is
   begin
      if kname = none then
	 return;
      end if;
      declare
	 val_record : root_option_record :=
	   root_option_record'(
			especie => common ,
			is_valid => true,
			value_nature => nat_ptr_my_bool,
			key_ssl => none ,
			key_common => kname,
			value_s => ada.Strings.Unbounded.To_Unbounded_String(""),
			value_u => 0,
			value_b => kval
		       );
      begin
	 key_nameval(
	      L     => c.keyname_val_cache_common,
	      val   => val_record,
	      clear => clear );

      end;
   end add_key_nameval;

   ----
   ----
   ----


end apq.mysql.client.option_system;
