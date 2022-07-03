generic
   type Real is digits <>;
   type Granule is range <>;
package Water_Map is

   type Cell_Flags_all is
     (Has_Water, Is_Water_Source, Boring, Permanently_Boring, Carrying);
   subtype Cell_Flags is Cell_Flags_all range Has_Water .. Permanently_Boring;
   -- sediment is not yet implemented

   type Dimension is (X, Y);

   type Vector is array (Dimension) of Real;

   type Map_Cell (Flags : Cell_Flags := Boring) is record
      Land_Height : Real;
      case Flags is
         when Has_Water | Is_Water_Source | Boring =>
            case Flags is
               when Has_Water | Is_Water_Source =>
                  Velocity       : Vector;
                  Delta_Velocity : Vector;

                  Water_Depth : Real;
                  case Flags is
                     when Has_Water =>
                        Delta_Water_Depth : Real;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         when others =>
            null;
      end case;
   end record;

   type Water_Map_Type is array (Granule,Granule) of Map_Cell;

end Water_Map;
