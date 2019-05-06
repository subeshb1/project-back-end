# frozen_string_literal: true
# By default ActiveModelSerializers will use the Attributes Adapter (no JSON root)
ActiveModelSerializers.config.adapter = :attributes #:json, :json_api
