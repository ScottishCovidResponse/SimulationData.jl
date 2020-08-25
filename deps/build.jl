using Pkg
ENV["PYTHON"] = ""
Pkg.build("PyCall")

using PyCall

const PACKAGES = ["scipy", "pyyaml", "setuptools-scm", "aiohttp", "git+https://github.com/ScottishCovidResponse/data_pipeline_api@0.7.0"]

try
    @pyimport pip
catch
    get_pip = joinpath(dirname(@__FILE__), "get-pip.py")
    download("https://bootstrap.pypa.io/get-pip.py", get_pip)
    run(`$(PyCall.python) $get_pip --user`)
end

args = UTF8String[]
if haskey(ENV, "http_proxy")
    push!(args, "--proxy")
    push!(args, ENV["http_proxy"])
end
push!(args, "install")
push!(args, "--user")
append!(args, PACKAGES)

@pyimport pip
pip.main(args)
