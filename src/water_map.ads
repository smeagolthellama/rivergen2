generic
   -- Floating point type for underlying simulation
   type Real is digits <>;
   -- Granularity for simulation
   type Granule is range <>;
   -- should add some physical constants such as gravity, as well as parameters
   -- such as the size of a single cell.
package Water_Map is

   -- all planned cell flags
   type Cell_Flags_all is
     (Has_Water, -- cells with water, only influenced by physics.
      Is_Levelled_Water, -- Cells with a constant level of water, adding or removing to maintain the level
      Is_Water_Inlet, -- Cells that add a constant rate of water per time step
      Boring, -- Cells that will be ignored until water gets added.
      Permanently_Boring, -- Cells that will never be affected by physics, with a constant 0 level of water
      Carrying -- Cells that are carrying sediment
   ); -- all planned cell flags

   -- implemented flags
   --
   -- sediment is not yet implemented
   subtype Cell_Flags is Cell_Flags_all range Has_Water .. Permanently_Boring;

   -- index type for vectors.
   type Dimension is (X, Y);

   -- vectors. unit is velocity.
   type Vector is array (Dimension) of Real;

   -- individual map cells
   -- @field Flags flags for cell type, determining accessible fields and behaviour.
   -- @field Land_Height height of the land under the water. Height
   -- @field Velocity velocity of the water in the cell. Speed.
   -- @field Delta_Velocity change of velocity being calculated for this time step. Speed (diff).
   -- @field Water_Depth the depth of the water in this cell. Height.
   -- @field Delta_Water_Depth change of water depth, calculated for this time step. Height (diff).
   -- @field Rate rate of water being added. volume/time.
   type Map_Cell (Flags : Cell_Flags := Boring) is record
      Land_Height : Real;

      case Flags is
         when Has_Water | Is_Levelled_Water | Is_Water_Inlet =>
            Velocity       : Vector;
            Delta_Velocity : Vector;

            Water_Depth : Real;
            case Flags is
               when Has_Water | Is_Water_Inlet =>
                  Delta_Water_Depth : Real;
                  case Flags is
                     when Is_Water_Inlet =>
                        Rate : Real;
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

   -- The actual map on which the physics takes place.
   type Water_Map_Type is array (Granule, Granule) of Map_Cell;

end Water_Map;
