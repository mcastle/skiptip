defmodule Skiptip.Searches do

  import Ecto.Query
  import Geo.PostGIS

  alias Skiptip.Location
  alias Skiptip.Repo
  alias Skiptip.RidesProviderProfile


  # rounded up to nearest meter
  @meters_in_mile 1610

  def rides(coordinates) do
    my_point = Location.point(coordinates)
    query = from l in Location,
            join: r in RidesProviderProfile,
            on: r.available == true and l.user_id == r.user_id,
            select: l.user_id,
            where: st_dwithin(l.point, ^my_point, ^@meters_in_mile)
    Repo.all(query)
  end

end
