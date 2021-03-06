defmodule Snitch.Factory.Address do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Snitch.Data.Schema.{State, Country, Address}

      def state_factory do
        %State{
          name: "California",
          abbr: sequence("CA"),
          country: build(:country)
        }
      end

      def country_factory do
        %Country{
          iso_name: sequence("UNITED STATES"),
          iso: sequence("U"),
          iso3: sequence("US"),
          name: sequence("United States"),
          numcode: sequence("840"),
          states_required: true
        }
      end

      def address_factory do
        %Address{
          first_name: "Tony",
          last_name: "Stark",
          address_line_1: "10-8-80 Malibu Point",
          zip_code: "90265",
          city: "Malibu",
          phone: "1234567890"
          # state_id: State.get_id("California"),
          # country_id: Country.get_id("USA"),
        }
      end

      def states(context) do
        count = Map.get(context, :state_count, 1)
        [states: insert_list(count, :state)]
      end

      def countries(context) do
        count = Map.get(context, :country_count, 1)
        [countries: insert_list(count, :country)]
      end
    end
  end
end
