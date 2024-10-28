defmodule TodolistWeb.Utils do
  def generate_csrf_token do
    :crypto.strong_rand_bytes(40)
    |> Base.url_encode64(padding: false)
    |> String.slice(0..49)
  end

  # defmodule TodolistWeb.Utils do
  #   @csrf_token_length 50

  #   def generate_csrf_token() do
  #     :crypto.strong_rand_bytes(@csrf_token_length)
  #     |> Base.encode64()
  #     |> binary_part(0, @csrf_token_length)  # This line is likely causing the issue
  #   end
  # end

end
