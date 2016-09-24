require 'cuba'
require 'mote'
require 'mote/render'

require_relative 'lib/db'

Cuba.plugin(Mote::Render)
Cuba.settings[:mote][:views] = "./views/"

Cuba.define do
  def base_model
    Model.new(items: DB.item_queries.run(:all))
  end

  on "change-item/:id" do |id|

    on "in-progress" do
      DB.item_queries.run(:update_status, status: 'in_progress', id: id)
      res.redirect("/")
    end

    on "done" do
      DB.item_queries.run(:update_status, status: 'done', id: id)
      res.redirect("/")
    end

    on "todo" do
      DB.item_queries.run(:update_status, status: 'todo', id: id)
      res.redirect("/")
    end

    on "destroy" do
      DB.item_queries.run(:destroy, id: id)
      res.redirect("/")
    end

    on default do
      res.redirect("/")
    end

  end

  on post do
    on "item/create", param("name") do |name|
      DB.item_queries.run(:new, name: name)
      res.redirect("/")
    end

    on default do
      res.redirect("/")
    end
  end

  on default do
    res.write(view("index", model: base_model))
  end
end

class Model
  attr_reader :items

  def initialize(items:)
    @items = items
  end

  def done
    items.select { |item| item.done? }
  end

  def todo
    items.select { |item| item.todo? }
  end

  def in_progress
    items.select { |item| item.in_progress? }
  end
end
