defmodule Crawler.Utils.ParseHelper do

  def find_first_as_string(document, selector) do
    try do
      document
      |> Floki.find(selector)
      |> List.first()
      |> Floki.text()
      |> String.trim()
    rescue
      _ -> ""
    end
  end

  def find_first_attribute_as_string(document, selector, attribute) do
    try do
      document
      |> Floki.find(selector)
      |> Floki.attribute(attribute)
      |> List.first()
      |> String.trim()
    rescue
      _ -> ""
    end
  end
end