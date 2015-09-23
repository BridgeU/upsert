require 'spec_helper'
describe Upsert do
  describe 'id column return' do
    it "doesn't confuse selector and setter" do
      p = Pet.new
      p.name = 'Jerry'
      p.tag_number = 5
      p.save!

      pet_id = p.id

      u = Upsert.new($conn, :pets, id_column_name: 'id')
      selector = { :name => 'Jerry' }
      setter = { :tag_number => 10 }
      result = u.row(selector, setter)
      result.should == pet_id

      u = Upsert.new($conn, :pets, id_column_name: 'id')
      selector = { :name => 'Jerry', :tag_number => 5 }
      result = u.row(selector, setter)
      # nil result because no row was changed
      result.should == nil

      u = Upsert.new($conn, :pets, id_column_name: 'id')
      selector = { :name => 'Made up name' }
      setter = { :tag_number => 10 }
      result = u.row(selector, setter)
      Pet.find(result).name.should == "Made up name"
    end
  end
end
