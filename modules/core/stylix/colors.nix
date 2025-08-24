{ pkgs, ... }:
{
  stylix = {
    # Esquema de colores Nord definido directamente
    base16Scheme = {
      base00 = "#2e3440"; # Polar Night - Fondo más oscuro
      base01 = "#3b4252"; # Polar Night - Fondo ligeramente más claro
      base02 = "#434c5e"; # Polar Night - Selección/fondo de selección
      base03 = "#4c566a"; # Polar Night - Comentarios, invisibles
      base04 = "#d8dee9"; # Snow Storm - Texto oscuro
      base05 = "#e5e9f0"; # Snow Storm - Texto principal/por defecto
      base06 = "#eceff4"; # Snow Storm - Texto claro
      base07 = "#8fbcbb"; # Frost - Texto más claro
      base08 = "#bf616a"; # Aurora - Rojo (error, eliminado)
      base09 = "#d08770"; # Aurora - Naranja (warning, variable)
      base0A = "#ebcb8b"; # Aurora - Amarillo (clase, modificado)
      base0B = "#a3be8c"; # Aurora - Verde (añadido, string)
      base0C = "#88c0d0"; # Frost - Cyan (soporte, regex)
      base0D = "#81a1c1"; # Frost - Azul (función, método)
      base0E = "#b48ead"; # Aurora - Morado (keyword, tag)
      base0F = "#5e81ac"; # Frost - Azul oscuro (deprecated)
    };
    
    polarity = "dark";
  };
}

