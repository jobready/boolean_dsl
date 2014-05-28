require 'spec_helper'

describe BooleanDsl::Parser do
  let(:parser) { described_class.new }

  context 'numeric literals' do
    specify { expect(parser.parse('0')).to eq(integer: "0") }
    specify { expect(parser.parse('1')).to eq(integer: "1") }
    specify { expect(parser.parse('12')).to eq(integer: "12") }
    specify { expect(parser.parse('0 ')).to eq(integer: "0") }
    specify { expect(parser.parse('12   ')).to eq(integer: "12") }
  end

  context 'string literals' do
    specify { expect(parser.parse("''")).to eq(string: []) } #TODO: https://github.com/kschiess/parslet/pull/98
    specify { expect(parser.parse("' '")).to eq(string: ' ') }
    specify { expect(parser.parse("'potato'")).to eq(string: 'potato') }
    specify { expect(parser.parse("'I am, 12345, \"you\" are'")).to eq(string: 'I am, 12345, "you" are') }
    specify { expect(parser.parse("'I am, 12345, \"you\" are'   ")).to eq(string: 'I am, 12345, "you" are') }
  end

  context 'attributes' do
    specify { expect(parser.parse("first_name")).to eq(attribute: 'first_name') }
  end

  context 'operators' do
    context 'comparison' do
      specify do
        expect(parser.parse('1 == 1')).to eq(
          left: { integer: "1" },
          comparison_operator: "==",
          right: { integer: "1" }
        )
      end

      specify do
        expect(parser.parse('16 == 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: "==",
          right: { integer: "9565" }
        )
      end

      specify do
        expect(parser.parse("575 == '575'")).to eq(
          left: { integer: "575" },
          comparison_operator: "==",
          right: { string: "575" }
        )
      end

      specify do
        expect(parser.parse('16 < 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: "<",
          right: { integer: "9565" }
        )
      end
    end
  end
=begin
  context 'combining expressions' do
    specify do
      expect(parser.parse('1 == 1 && 2 == 2')).to eq(
        {})
    end
  end
=end
end
