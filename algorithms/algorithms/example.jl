using Pkg
pkg"activate ."

using Genie, Genie.Router, Genie.Renderer
using Genie.Renderer.Html


form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <input type="text" name="greeting" value="hello genie" /><br/>
  <input type="file" name="fileupload" /><br/>
  <input type="submit" value="Submit" />
</form>
"""

route("/") do
  html(form)
end

route("/", method = POST) do
  for (name,file) in @params(:FILES)
    write(file.name, IOBuffer(file.data))
    println("Num")
  end
  
  @show @params(:greeting)

  @params(:greeting)
end

Genie.AppServer.startup(8001,async = false)
