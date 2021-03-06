require 'restaurant'

ITEMS_LIST = [ {:dish=>"Supa Minestrone", :qty=>3},
               {:dish=>"Margherita", :qty=>3}
             ]
TEST_MENU = "menu"
TEST_MESSAGE = "Text Message"

describe Restaurant do
  subject(:restaurant){ described_class.new(ITEMS_LIST)}
  subject(:other_restaurant){ described_class.new}
  let(:menu){ double('menu') }
  let(:order){ double('order') }
  before :each do
    Menu.send(:remove_const, "FILENAME")
    Menu::FILENAME = "./lib/list_dishes_test.csv"
  end

  describe '#look_menu' do
    it 'check if want to order something' do
      expect(restaurant).to respond_to(:look_menu)
    end

    it 'Tests printer' do
      expect(menu).to receive(:printer)
      restaurant.look_menu(menu)
      # OR
      # allow(menu).to receive(:printer).and_return(TEST_MENU)
      # expect(restaurant.look_menu(menu)).to eq(TEST_MENU)
    end
  end

  describe '#choose_items' do
    it {is_expected.to respond_to(:choose_items).with(2).argument}

    it 'Choose items and quantities' do
      restaurant.choose_items("Supa Minestrone",3)
      restaurant.choose_items("Margherita",3)
      expect(restaurant.pre_order).to eq(ITEMS_LIST)
    end
  end

  describe '#calculate_amount' do
    it {is_expected.to respond_to(:calculate_amount)}

    context 'When preorder not empty' do
      it 'Calculates an amount' do
        allow(order).to receive(:calculate_total).and_return(6)
        expect(restaurant.calculate_amount(order)).to eq(6)
      end
    end

    context 'When preorder empty' do
      it 'raises an error' do
        expect{other_restaurant.calculate_amount(order)}.to raise_error("There are no items in the basket")
      end
    end
  end

  describe '#amount_check?' do
    it {is_expected.to respond_to(:amount_check?)}

    it 'Checks if calculations are well executaded' do
      allow(order).to receive(:calculate_total).and_return(12)
      restaurant.calculate_amount
      restaurant.estimated_amount = 12
      expect(restaurant).to be_amount_check
    end
  end

  describe '#place_order' do
    it {is_expected.to respond_to(:place_order)}

    it 'Raises error if total is incorrect' do
      allow(order).to receive(:calculate_total).and_return(6)
      restaurant.calculate_amount
      expect{ restaurant.place_order }.to raise_error("Incorrect sum")
    end
  end
end
