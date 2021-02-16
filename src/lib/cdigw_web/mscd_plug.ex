defmodule CdigwWeb.MscdPlug do
  @moduledoc """
  Handle request for MSCD: the Windows 2000 CD Player
  """

  import Plug.Conn
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    {:ok, toc} = Mscd.RequestParser.parse_query(conn.query_params["cd"])
    mb_disc_id = MusicBrainz.calculate_disc_id(toc.lead_out_lba, toc.track_lbas)
    {:ok, %{"releases" => [release | _]}} = MusicBrainz.get_releases_by_disc_id(mb_disc_id)
    disc = MusicBrainz.release_to_disc(nil, release)
    response = Mscd.Response.render(disc)

    conn |> send_resp(200, response)
  end
end
