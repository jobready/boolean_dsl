require 'spec_helper'

describe BooleanDsl::Parser do
  let(:parser) { described_class.new }

  context 'numeric literals' do
    specify { expect(parser.parse_with_debug('0')).to eq(integer: "0") }
    specify { expect(parser.parse_with_debug('1')).to eq(integer: "1") }
    specify { expect(parser.parse_with_debug('12')).to eq(integer: "12") }
    specify { expect(parser.parse_with_debug('0 ')).to eq(integer: "0") }
    specify { expect(parser.parse_with_debug('12   ')).to eq(integer: "12") }
  end

  context 'string literals' do
    specify { expect(parser.parse_with_debug("''")).to eq(string: []) } #TODO: https://github.com/kschiess/parslet/pull/98
    specify { expect(parser.parse_with_debug("' '")).to eq(string: ' ') }
    specify { expect(parser.parse_with_debug("'potato'")).to eq(string: 'potato') }
    specify { expect(parser.parse_with_debug("'I am, 12345, \"you\" are'")).to eq(string: 'I am, 12345, "you" are') }
    specify { expect(parser.parse_with_debug("'I am, 12345, \"you\" are'   ")).to eq(string: 'I am, 12345, "you" are') }
  end

  context 'attributes' do
    specify { expect(parser.parse_with_debug("first_name")).to eq(attribute: 'first_name') }
    specify { expect(parser.parse_with_debug("aqf3_cert")).to eq(attribute: 'aqf3_cert') }
    specify { expect(parser.parse_with_debug("cert_3")).to eq(attribute: 'cert_3') }
    specify { expect(parser.parse_with_debug("dare21_?")).to eq(attribute: 'dare21_?') }
  end

  context 'parens' do
    specify { expect(parser.parse_with_debug('(1)')).to eq(expression: { integer: "1" }) }
    specify { expect(parser.parse_with_debug("('alpha')")).to eq(expression: { string: "alpha" }) }
    specify { expect(parser.parse_with_debug("(aqf_cert)")).to eq(expression: { attribute: "aqf_cert" }) }
    specify do
      expect(parser.parse_with_debug("(1 == 1)")).to eq(
        expression: {
          left: { integer: "1" },
          comparison_operator: "==",
          right: { integer: "1" }
        }
      )
    end
  end

  context 'operators' do
    context 'comparison' do
      specify do
        expect(parser.parse_with_debug('1 == 1')).to eq(
          left: { integer: "1" },
          comparison_operator: "==",
          right: { integer: "1" }
        )
      end

      specify do
        expect(parser.parse_with_debug('16 == 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: "==",
          right: { integer: "9565" }
        )
      end

      specify do
        expect(parser.parse_with_debug('gamma == 7  ')).to eq(
          left: { attribute: "gamma" },
          comparison_operator: "==",
          right: { integer: "7" }
        )
      end

      specify do
        expect(parser.parse_with_debug("575 == '575'")).to eq(
          left: { integer: "575" },
          comparison_operator: "==",
          right: { string: "575" }
        )
      end

      specify do
        expect(parser.parse_with_debug('16 < 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: "<",
          right: { integer: "9565" }
        )
      end

      specify do
        expect(parser.parse_with_debug('16 >= 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: ">=",
          right: { integer: "9565" }
        )
      end

      specify do
        expect(parser.parse_with_debug('16 != 9565  ')).to eq(
          left: { integer: "16" },
          comparison_operator: "!=",
          right: { integer: "9565" }
        )
      end
    end

    context 'boolean' do
      specify do
        expect(parser.parse_with_debug('1 == 1 and 2 == 2   ')).to eq(
          left: {
            left: { integer: "1" },
            comparison_operator: "==",
            right: { integer: "1" }
          },
          boolean_operator: "and",
          right: {
            left: { integer: "2" },
            comparison_operator: "==",
            right: { integer: "2" }
          }
        )
      end

      specify do
        expect(parser.parse_with_debug('1 > 0 or alpha ')).to eq(
          left: {
            left: { integer: "1" },
            comparison_operator: ">",
            right: { integer: "0" }
          },
          boolean_operator: "or",
          right: {
            attribute: "alpha"
          }
        )
      end

      specify do
        expect(parser.parse_with_debug('1 < 2 and 6 == 2 and 8 > 3')).to eq(
          left: {
            left: { integer: "1" },
            comparison_operator: "<",
            right: { integer: "2" }
          },
          boolean_operator: "and",
          right: {
            left: {
              left: { integer: "6" },
              comparison_operator: "==",
              right: { integer: "2" }
            },
            boolean_operator: "and",
            right: {
              left: { integer: "8" },
              comparison_operator: ">",
              right: { integer: "3" }
            }
          }
        )
      end

      specify do
        expect(parser.parse_with_debug('(1 < 2 or 6 == 2) and 8 > 3')).to eq(
          left: {
            expression: {
              left: {
                left: { integer: "1" },
                comparison_operator: "<",
                right: { integer: "2" }
              },
              boolean_operator: "or",
              right: {
                left: { integer: "6" },
                comparison_operator: "==",
                right: { integer: "2" }
              }
            }
          },
          boolean_operator: "and",
          right: {
            left: { integer: "8" },
            comparison_operator: ">",
            right: { integer: "3" }
          }
        )
      end
    end
  end

=begin
  context 'error cases' do
    %w(
      
    )
  end
=end
end
