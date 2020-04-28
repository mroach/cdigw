defmodule Mscd.RequestParser do
  @doc """
      iex> Mscd.RequestParser.parse_query("D 96 3B87 73B9 B2C3 EFEC 12856 165FA 1A976 1E332 22277 257F5 29517 2E04F 32110")
      %{
        track_count: 13,
        track_lbas: [150, 15239, 29625, 45763, 61420, 75862, 91642, 108918, 123698, 139895, 153589, 169239, 188495],
        lead_out_lba: 205072
      }
  """
  def parse_query(query) when is_binary(query) do
    query
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1, 16))
    |> parse_query()
  end

  def parse_query([track_count | lbas]) do
    {track_lbas, [lead_out_lba]} = Enum.split(lbas, track_count)

    %{track_count: track_count, track_lbas: track_lbas, lead_out_lba: lead_out_lba}
  end
end
