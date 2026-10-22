<%@ Page Title="Lisa laps" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact3.aspx.vb" Inherits="ER_diagramm_VS_E.Contact3" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Lisa laps</h2>
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="laps_id"
        DataSourceID="SqlDataSource1_laps_lisa" DefaultMode="Insert" Height="50px" Width="450px"
        OnItemInserted="DetailsView1_ItemInserted">
        <Fields>
            <asp:TemplateField HeaderText="Laps">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListLaps" runat="server" DataSourceID="SqlDataSource2_laps"
                        DataTextField="nimi" DataValueField="laps_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("laps_id") %>'>
                        <asp:ListItem Value="">(uus laps)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_laps" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT laps_id, eesnimi + ' ' + perenimi AS nimi FROM [Laps] ORDER BY perenimi, eesnimi"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Soovitud rühm">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListSoovitud" runat="server" DataSourceID="SqlDataSource2_soovitud"
                        DataTextField="nimetus" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("soovitud_ruhm_id") %>'>
                        <asp:ListItem Value="">(pole valitud)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_soovitud" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT ruhm_id, nimetus FROM [Ruhm] ORDER BY nimetus"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Staatus (järjekord)">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListStaatus" runat="server" SelectedValue='<%# Bind("staatus") %>'>
                        <asp:ListItem Value="">(pole järjekorras)</asp:ListItem>
                        <asp:ListItem>ootel</asp:ListItem>
                        <asp:ListItem>pakutud</asp:ListItem>
                        <asp:ListItem>vastu võetud</asp:ListItem>
                        <asp:ListItem>tühistatud</asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" />
            <asp:TemplateField HeaderText="Sünniaeg">
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBoxSynniaeg" runat="server" TextMode="Date" Text='<%# Bind("synniaeg") %>'></asp:TextBox>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Rühm (lapsi/kohti)">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListRuhm" runat="server" DataSourceID="SqlDataSource2_ruhm"
                        DataTextField="nimi" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("ruhm_id") %>'>
                        <asp:ListItem Value="">(pole rühmas)</asp:ListItem>
                    </asp:DropDownList>
                    <%-- Rühma nimi koos praeguse laste arvu ja kohtade arvuga, nt "Mõmmikud (1/14)" --%>
                    <asp:SqlDataSource ID="SqlDataSource2_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT Ruhm.ruhm_id, Ruhm.nimetus + ' (' + CAST((SELECT COUNT(*) FROM Ruhmas_olek WHERE Ruhmas_olek.ruhm_id = Ruhm.ruhm_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31')) AS varchar(10)) + '/' + CAST(Ruhm.kohtade_arv AS varchar(10)) + ')' AS nimi FROM Ruhm ORDER BY Ruhm.nimetus"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Rühmas alates (tühi = täna)">
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBoxAlgus" runat="server" TextMode="Date" Text='<%# Bind("alguse_kp") %>'></asp:TextBox>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowInsertButton="True" InsertText="Lisa" CancelText="Tühista" NewText="Uus" />
        </Fields>
    </asp:DetailsView>

    <%-- Üks vorm kolme tabeli jaoks (kõik ühes tehingus):
         1) Laps: kui valiti (uus laps), lisatakse uus laps (eesnimi, perenimi, sünniaeg on kohustuslikud);
         2) Jarjekord: kui staatus valiti, lisatakse järjekorra kirje (soovitud rühm võib olla tühi);
         3) Ruhmas_olek: kui rühm valiti, lõpeb eelmine rühm päev enne uut algust ja lisatakse uus rühm;
            kui staatust ei valitud, märgitakse lapse ootel/pakutud järjekorra kirjed "vastu võetud". --%>
    <asp:SqlDataSource ID="SqlDataSource1_laps_lisa" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT [laps_id], [eesnimi], [perenimi], [synniaeg] FROM [Laps]"
        InsertCommand="SET XACT_ABORT ON;
            DECLARE @laps int = @laps_id, @algus date = ISNULL(@alguse_kp, CAST(GETDATE() AS date));
            BEGIN TRY BEGIN TRAN;
            IF @laps IS NULL
            BEGIN
                IF @eesnimi IS NULL OR @perenimi IS NULL OR @synniaeg IS NULL
                    THROW 50010, N'Uue lapse jaoks täida eesnimi, perenimi ja sünniaeg (või vali olemasolev laps).', 1;
                INSERT INTO [Laps] ([eesnimi], [perenimi], [synniaeg]) VALUES (@eesnimi, @perenimi, @synniaeg);
                SET @laps = SCOPE_IDENTITY();
            END
            ELSE IF @staatus IS NULL AND @ruhm_id IS NULL
                THROW 50011, N'Olemasolevale lapsele vali staatus (järjekord) või rühm.', 1;
            IF @staatus IS NOT NULL
                INSERT INTO [Jarjekord] ([laps_id], [soovitud_ruhm_id], [staatus]) VALUES (@laps, @soovitud_ruhm_id, @staatus);
            IF @ruhm_id IS NOT NULL
            BEGIN
                UPDATE [Ruhmas_olek] SET [lopu_kp] = DATEADD(day, -1, @algus)
                    WHERE [laps_id] = @laps AND [lopu_kp] IS NULL AND [alguse_kp] BETWEEN '1900-01-01' AND DATEADD(day, -1, @algus);
                DELETE FROM [Ruhmas_olek] WHERE [laps_id] = @laps AND [alguse_kp] = @algus;
                INSERT INTO [Ruhmas_olek] ([laps_id], [ruhm_id], [alguse_kp]) VALUES (@laps, @ruhm_id, @algus);
                IF @staatus IS NULL
                    UPDATE [Jarjekord] SET [staatus] = N'vastu võetud'
                        WHERE [laps_id] = @laps AND [staatus] IN (N'ootel', N'pakutud');
            END
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <InsertParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
            <asp:Parameter Name="soovitud_ruhm_id" Type="Int32" />
            <asp:Parameter Name="staatus" Type="String" />
            <asp:Parameter Name="eesnimi" Type="String" />
            <asp:Parameter Name="perenimi" Type="String" />
            <asp:Parameter Name="synniaeg" Type="DateTime" />
            <asp:Parameter Name="ruhm_id" Type="Int32" />
            <asp:Parameter Name="alguse_kp" Type="DateTime" />
        </InsertParameters>
    </asp:SqlDataSource>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <h3>Lapsed ja järjekord</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="jarjekord_id"
        DataSourceID="SqlDataSource1_jarjekord_tabel" CssClass="table"
        OnRowUpdated="GridView1_RowUpdated" OnRowDeleted="GridView1_RowDeleted">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <%-- Edit/Delete ainult neil lastel, kes on järjekorras --%>
                    <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Muuda"
                        Visible='<%# Not IsDBNull(Eval("jarjekord_id")) %>'></asp:LinkButton>
                    <asp:LinkButton ID="LinkButtonDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Eemalda järjekorrast"
                        Visible='<%# Not IsDBNull(Eval("jarjekord_id")) %>'></asp:LinkButton>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:LinkButton ID="LinkButtonUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Salvesta"></asp:LinkButton>
                    <asp:LinkButton ID="LinkButtonCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Tühista"></asp:LinkButton>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="jarjekord_id" HeaderText="Järjekorra ID" ReadOnly="True" />
            <asp:TemplateField HeaderText="Laps">
                <ItemTemplate>
                    <asp:Label ID="LabelLaps" runat="server" Text='<%# Eval("nimi") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListLaps" runat="server" DataSourceID="SqlDataSource2_laps"
                        DataTextField="nimi" DataValueField="laps_id" SelectedValue='<%# Bind("laps_id") %>'>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_laps" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT laps_id, eesnimi + ' ' + perenimi AS nimi FROM [Laps] ORDER BY perenimi"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Soovitud rühm">
                <ItemTemplate>
                    <asp:Label ID="LabelRuhm" runat="server" Text='<%# Eval("ruhm") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListRuhm" runat="server" DataSourceID="SqlDataSource2_ruhm"
                        DataTextField="nimetus" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("soovitud_ruhm_id") %>'>
                        <asp:ListItem Value="">(pole valitud)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT * FROM [Ruhm]"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="lisamise_kp" HeaderText="Lisatud" ReadOnly="True" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:TemplateField HeaderText="Staatus">
                <ItemTemplate>
                    <asp:Label ID="LabelStaatus" runat="server" Text='<%# Eval("staatus_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListStaatus" runat="server" SelectedValue='<%# Bind("staatus") %>'>
                        <asp:ListItem>ootel</asp:ListItem>
                        <asp:ListItem>pakutud</asp:ListItem>
                        <asp:ListItem>vastu võetud</asp:ListItem>
                        <asp:ListItem>tühistatud</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1_jarjekord_tabel" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Jarjekord.jarjekord_id, Laps.laps_id, Jarjekord.soovitud_ruhm_id, Laps.eesnimi + ' ' + Laps.perenimi AS nimi, Ruhm.nimetus AS ruhm, Jarjekord.lisamise_kp, Jarjekord.staatus, ISNULL(Jarjekord.staatus, N'pole järjekorras') AS staatus_tekst FROM Laps LEFT JOIN Jarjekord ON Jarjekord.laps_id = Laps.laps_id LEFT JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id ORDER BY Laps.perenimi, Laps.eesnimi, Jarjekord.jarjekord_id"
        UpdateCommand="UPDATE [Jarjekord] SET [laps_id] = @laps_id, [soovitud_ruhm_id] = @soovitud_ruhm_id, [staatus] = @staatus WHERE [jarjekord_id] = @jarjekord_id"
        DeleteCommand="DELETE FROM [Jarjekord] WHERE [jarjekord_id] = @jarjekord_id">
        <UpdateParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
            <asp:Parameter Name="soovitud_ruhm_id" Type="Int32" />
            <asp:Parameter Name="staatus" Type="String" />
            <asp:Parameter Name="jarjekord_id" Type="Int32" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="jarjekord_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
