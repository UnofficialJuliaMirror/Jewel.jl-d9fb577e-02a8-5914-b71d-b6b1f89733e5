# Result tracking

import Base.Random: uuid4, UUID

type Result
  id::UUID
  value
  data
end

Result(id, value) = Result(id, value, Dict())

Base.string(r::Result) = "\"" * string(r.id) * "\""

const results = (UUID=>Result)[]

handle("result.clear") do _, id
  delete!(results, UUID(id))
end

function register_result(result)
  id = uuid4()
  results[id] = Result(id, result)
end

# Raise on results

raise(obj::UUID, event, args...) =
  raise(global_client, :raise, {:id => string(obj),
                                :event => event,
                                :args => args})

raise(obj::Result, args...) = raise(obj.id, args...)

# Evaluate Julia code

handle("eval.julia") do ed, code
  include_string(code)
end
