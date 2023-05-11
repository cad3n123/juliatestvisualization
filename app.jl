using Gtk

win = GtkWindow("A new window")
canvas = @GtkCanvas()
g = GtkGrid()

a = GtkEntry()  # a widget for entering text
set_gtk_property!(a, :text, "This is Gtk!")
b = GtkCheckButton("Check me!")
c = GtkScale(false, 0:10)     # a slider

liststore = GtkListStore(String, String, String, String)
push!(liststore, ("Mutt", "Bonzo", "7", "9.9"))
push!(liststore, ("Mutt", "Crash", "3", "6.5"))
push!(liststore, ("Border Collie", "Oakley", "11", "12.3"))
push!(liststore, ("Golden Retriever", "Buddy", "5", "11.2"))
push!(liststore, ("Maine Coon", "Whiskers", "2", "4.7"))
push!(liststore, ("Siamese", "Luna", "4", "3.8"))
push!(liststore, ("Labrador Retriever", "Max", "3", "10.1"))
push!(liststore, ("Persian", "Fluffy", "6", "5.6"))
push!(liststore, ("German Shepherd", "Rocky", "8", "15.2"))
push!(liststore, ("Bulldog", "Spike", "4", "8.7"))
push!(liststore, ("Ragdoll", "Milo", "2", "4.1"))
push!(liststore, ("Poodle", "Fifi", "7", "6.9"))





title = GtkLabel("Title")
treeview = GtkTreeView(GtkTreeModel(liststore))

#Make the columns
renderertext = GtkCellRendererText()
columns = [GtkTreeViewColumn("Breed", renderertext, Dict([("text", 0)])), GtkTreeViewColumn("Name", renderertext, Dict([("text", 1)])), GtkTreeViewColumn("Age", renderertext, Dict([("text", 2)])), GtkTreeViewColumn("Weight", renderertext, Dict([("text", 3)]))]

#Add columns to treeview
for column in columns 
    push!(treeview, column)
end

#Sorting
for (i,c) in enumerate(columns)
    GAccessor.sort_column_id(c,i-1)
end

#Selecting
selection = GAccessor.selection(treeview)

#canvas
@guarded draw(canvas) do widget
    ctx = getgc(canvas)
    h = height(canvas)
    w = width(canvas)

    i = 1
    while (i < length(liststore) + 1)
        age = parse(Int, liststore[i, 3])
        weight = parse(Float64, liststore[i, 4])

        rectangle(ctx, (age/20) * (4w/5), (weight/20) * (4h/5), 6, 6)
        println("X Coord: ", string(trunc((age/20) * (4w/5))))
        set_source_rgb(ctx, 1, 0, 0)
        fill(ctx)
        i += 1
    end
end

# Now let's place these graphical elements into the Grid:
g[1:16, 1] = title
g[2:7, 2] = treeview
g[9:14, 2] = canvas
set_gtk_property!(g, :column_homogeneous, true)
set_gtk_property!(g, :column_spacing, 15)  # introduce a 15-pixel gap between columns
push!(win, g)
showall(win)
