module KnifeCookbook
  module RunListHelper
    def merge_run_list(*args)
     args.map { |arg| Enumerable === arg ? convert(arg) : arg }.flatten
    end

    private
    def convert(items)
      items.to_a.map { |i| i.to_s }
    end
  end
end