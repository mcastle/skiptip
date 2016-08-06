defmodule Skiptip.Searches do

  import Ecto.Query
  import Geo.PostGIS

  alias Skiptip.Location
  alias Skiptip.Repo


  # rounded up to nearest meter
  @meters_in_mile 1610

  def rides(coordinates) do
    my_point = Location.point(coordinates)
    query = from l in Location,
            select: l.user_id,
            #select: [l.point, st_distance(l.point, ^my_point)]
            where: st_dwithin(l.point, ^my_point, ^@meters_in_mile)
    Repo.all(query)

    #raise Repo.all(query)
  end

end
