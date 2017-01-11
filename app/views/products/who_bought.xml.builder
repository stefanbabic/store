format.xml { render( xml: @product.to_xml(
  only: [ :title, :updated_at ],
  skip_types: true,
  include: {
    orders: {
      except: [ :created_at, :updated_at ],
      skip_types: true,
      include: {
        line_items: {
          skip_types: true,
          except: [ :created_at, :updated_at, :cart_id, :order_id ]
        }
      }
    }
  }
)) }
