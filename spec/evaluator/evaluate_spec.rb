require 'spec_helper'

describe 'BooleanDsl::Evaluator#evaluate' do
  let(:evaluator) { BooleanDsl::Evaluator.new(nil, nil) }

  specify { expect(evaluator.evaluate(integer: '57')).to eq(57) }
  specify { expect(evaluator.evaluate(string: 'alpha5')).to eq('alpha5') }

  specify do
    expect(evaluator.evaluate(
      left: { integer: '1' },
      comparison_operator: '==',
      right: { integer: '1' },
    )).to be_true
  end
  specify do
    expect(evaluator.evaluate(
      left: { integer: '1' },
      comparison_operator: '<',
      right: { integer: '1' },
    )).to be_false
  end
  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      },
      boolean_operator: 'and',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_true
  end
  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '7' },
      },
      boolean_operator: 'and',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_false
  end
  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '9' },
      },
      boolean_operator: 'or',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_true
  end
  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '9' },
      },
      boolean_operator: 'or',
      right: {
        left: { integer: '7' },
        comparison_operator: '==',
        right: { integer: '2' },
      }
    )).to be_false
  end

  specify do
    expect(evaluator.evaluate(
      expression: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' }
      }
    )).to be_true
  end

  specify do
    expect(evaluator.evaluate(
      expression: {
        left: { integer: '1' },
        comparison_operator: '!=',
        right: { integer: '1' }
      }
    )).to be_false
  end
end