defmodule Cddb do
  @moduledoc """
  High level interface and configuration for CDDB
  """

  # Official list of genres in the CDDB protocol, but it seems that just about
  # any string is acceptable and indeed found in CDDB resources.
  @genres ~w[data folk jazz misc rock country blues newage reggae classical soundtrack]

  @doc """
  Default protocol version when not specified by the client.

  Valid levels are 1 - 6
  """
  def default_proto, do: 5

  @doc """
  Line ending to use in CDDB responses.

  The CDDB protocol specifies that `\\n`, `\\r\\n`, and `\\r` are all valid.
  """
  def line_separator, do: "\n"

  @doc """
  Terminator for message replies.
  """
  def eof_marker, do: "."

  @doc """
  Default list of known genres as specified in the CDDB protocol.
  """
  def genres, do: @genres

  @doc """
  Get the encoding name and encoded response appropriate for the `proto` level.

  When encoding for ISO-8859-1, invalid chars are replaced with `"?"`

      iex> Cddb.encode_response("Łódźstraße", 6)
      {"utf-8", "Łódźstraße"}

      iex> Cddb.encode_response("Łódźstraße", 5)
      {"iso-8859-1", "?\\xF3d?stra\\xDFe"}
  """
  def encode_response(response, proto) do
    case proto do
      6 ->
        {"utf-8", response}

      _ ->
        {"iso-8859-1", Encoding.to_latin1(response)}
    end
  end
end
