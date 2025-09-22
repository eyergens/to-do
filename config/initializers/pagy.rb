# frozen_string_literal: true

Pagy::DEFAULT[:limit] = 10 # items per page
Pagy::DEFAULT[:size]  = 8  # nav bar links
# Better user experience handled automatically
require 'pagy/extras/bootstrap'
require 'pagy/extras/overflow'
require 'pagy/extras/limit'
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:limit_extra] = true
