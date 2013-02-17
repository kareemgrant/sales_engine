require './test/test_helper'
require './lib/customer'
require './lib/customer_builder'
require './lib/invoice_builder'

class CustomerTest < MiniTest::Unit::TestCase


  def test_it_exists
    customer = Customer.new({})
    assert_kind_of Customer, customer
  end

  def test_it_is_initialized_from_a_hash_of_data
    data = {:id => '1', :first_name => 'Joey'}

    customer = Customer.new(data)
    assert_equal data[:id], customer.id
    assert_equal data[:first_name], customer.first_name
  end

  describe "test_random" do
    before do
      CustomerBuilder.parse_csv
      @data = Customer.all
    end

    def test_if_random
      c1 = Customer.random
      c2 = Customer.random

      20.times do
        break if c1.id != c2.id
        c1 = SalesEngine::Customer.random
      end

      refute_equal c1.id, c2.id
    end
  end

  describe "test_find_methods" do
    before do
      @c1 = {:id => '5', :first_name => 'MARY',
             :last_name => 'Smith',
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}

      @c2 = {:id => '7', :first_name => 'mary',
            :last_name => 'Smitty',
            :created_at => "2012-03-27 14:54:09 UTC",
            :updated_at => "2012-03-27 14:54:09 UTC"}

      @c3 = {:id => '7', :first_name => 'Mary Ellen',
            :last_name => 'Smutty',
            :created_at => "2012-03-27 14:54:09 UTC",
            :updated_at => "2012-03-27 14:54:09 UTC"}
      end

    def test_find_by_first_name_matches_first_result

      c2 = Customer.new(@c2)
      c1 = Customer.new(@c1)


      Customer.store([c1, c2])

      customer = Customer.find_by_first_name("Mary")
      assert_equal "MARY", customer.first_name
      assert_equal "5", customer.id
    end

    def test_find_all_by_first_name

      c1 = Customer.new(@c1)
      c2 = Customer.new(@c2)
      c3 = Customer.new(@c3)

      Customer.store([c1, c2, c3])

      customers = Customer.find_all_by_first_name("Mary")
      assert_equal 2, customers.count
    end

    def test_if_find_all_by_name_returns_empty_array_if_name_not_found

      c1 = Customer.new(@c1)
      c2 = Customer.new(@c2)

      Customer.store([c1, c2])

      customers = Customer.find_all_by_first_name("Joey")
      assert_equal [], customers
    end

    def test_find_by_id_matches_first_result

      c1 = Customer.new(@c2)
      c2 = Customer.new(@c3)

      Customer.store([c1, c2])

      customer = Customer.find_by_id("7")
      assert_equal "mary", customer.first_name
      assert_equal "7", customer.id
    end

    def test_find_all_by_id

      c1 = Customer.new(@c2)
      c2 = Customer.new(@c3)

      Customer.store([c1, c2])

      customers = Customer.find_all_by_id("7")
      assert_equal 2, customers.count
    end

    def test_if_find_all_by_id_returns_empty_array_if_id_not_found

      c1 = Customer.new(@c2)
      c2 = Customer.new(@c3)

      Customer.store([c1, c2])

      customers = Customer.find_all_by_id("10")
      assert_equal [], customers
    end
  end

  describe "customer relationships " do
    before do
      InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")

       c = {:id => '3', :first_name => 'MARY',
             :last_name => 'Smith',
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}

        @c = Customer.new(c)
    end

    def test_if_all_invoices_of_a_customer_can_be_retrieved
      invoices = Invoice.find_all_by_customer_id(@c.id)
      assert_equal 3, invoices.count
    end

  end

end