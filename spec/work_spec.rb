
#
# spec'ing h.js
#
# Wed May 16 06:11:34 JST 2018
#

require 'spec_helpers.rb'


describe 'H and workers' do

  describe '.makeWorker' do

    it 'creates a worker instance'# do
    #
    #  r =
    #    run(%{
    #      return H.makeWorker(function() {
    #        self.onmessage = function(m) {
    #          self.postMessage('worker got ' + JSON.stringify(m.data));
    #        };
    #      });
    #    })
    #
    #  expect(r).to eq(:xxx)
    #end
  end
end

