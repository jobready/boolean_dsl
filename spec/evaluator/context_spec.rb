require 'spec_helper'

describe 'BooleanDsl::Evaluator#evaluate with context' do
  class Context
    def alpha
      'omega'
    end

    def gamma
      7
    end

    def delta
      true
    end

    def yotta
      false
    end
  end

  let(:context) { Context.new }
  let(:evaluator) { BooleanDsl::Evaluator.new(nil, context) }

  context 'attribute' do
    specify { expect(evaluator.evaluate(attribute: 'alpha')).to eq('omega') }
    specify { expect(evaluator.evaluate(attribute: 'gamma')).to eq(7) }
    specify { expect(evaluator.evaluate(attribute: 'delta')).to be_true }
    specify { expect(evaluator.evaluate(attribute: 'yotta')).to be_false }
    specify do
      expect { evaluator.evaluate(attribute: 'beta') }.to(
        raise_error(BooleanDsl::EvaluationFailed, 'Context does not respond to beta'))
    end
  end

  context 'negation' do
    specify { expect(evaluator.evaluate(negation: { attribute: 'alpha' })).to eq(false) }
    specify { expect(evaluator.evaluate(negation: { attribute: 'yotta' })).to eq(true) }
  end

  context 'short circuit' do
    specify 'and' do
      expect(context).not_to receive(:delta)
      evaluator.evaluate(
        left: {
          attribute: 'yotta'
        },
        boolean_operator: 'and',
        right: {
          attribute: 'delta'
        }
      )
    end

    specify 'or' do
      expect(context).not_to receive(:yotta)
      evaluator.evaluate(
        left: {
          attribute: 'delta'
        },
        boolean_operator: 'or',
        right: {
          attribute: 'yotta'
        }
      )
    end
  end
end