package io.github.froodyapp.activity;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import java.util.ArrayList;
import java.util.Random;

import io.github.froodyapp.R;
import io.github.froodyapp.api.model_.FroodyEntry;
import io.github.froodyapp.api.model_.FroodyUser;
import io.github.froodyapp.model.FroodyEntryPlus;
import io.github.froodyapp.service.EntryPublisher;
import io.github.froodyapp.ui.BaseFragment;
import io.github.froodyapp.util.AppSettings;

/**
 * Activity for information about the app
 */
public class DevFragment extends BaseFragment implements View.OnClickListener {
    //########################
    //## Static
    //########################
    public static final String FRAGMENT_TAG = "DevFragment";

    public static DevFragment newInstance() {
        return new DevFragment();
    }

    //####################
    //##  Stuff
    //####################
    Button button;
    AppSettings appSettings;
    Random random;


    //####################
    //##  Methods
    //####################
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        button = new Button(inflater.getContext());
        button.setText("Do something");
        return button;
    }

    @Override
    @SuppressWarnings("deprecation")
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        button.setOnClickListener(this);
        Context context = getContext();
        appSettings = AppSettings.get();
        random = new Random();

        // Not on default server ;)
        if (appSettings.getFroodyServer().equals(getString(R.string.server_default))) {
            getFragmentManager().popBackStack();
            return;
        }

        ArrayList<FroodyEntryPlus> pub = new ArrayList<>();

        // FroodyUsers
        FroodyUser me = appSettings.getFroodyUser();

        //
        // German Data
        //
        FroodyEntryPlus fep = new FroodyEntryPlus(new FroodyEntry());
        fep.setAddress("Wolloester, Burgkirchen");
        fep.setContact("Gregor\nMail: gregor@froody-app.at\nTel: +43 677 42123123");
        fep.setDescription("Nimm soviele Äpfel wie du brauchst. Baum befindet sich an einem öffentlichen Platz");

        // One german entry
        FroodyEntryPlus tmp = fillWithRandomData(fep, 48.20198, 13.13342, 0);
        tmp.setCertificationType(0);
        tmp.setDistributionType(0);
        tmp.setEntryType(2);
        pub.add(tmp);

        // One english entry
        tmp = FroodyEntryPlus.getCopy(tmp);
        tmp.loadGeohashFromLocation(48.20193, 13.13281, 9);
        tmp.setEntryType(3);
        tmp.setDescription("Take what you need. Tree is located at a public location.");
        pub.add(tmp);

        // Another german entry
        tmp = FroodyEntryPlus.getCopy(tmp);
        tmp.loadGeohashFromLocation(48.20124, 13.13397, 9);
        tmp.setEntryType(13);
        pub.add(tmp);

        // Random entries
        for (int i = 0; i < 10; i++)
            pub.add(fillWithRandomData(fep, 48.20198, 13.13342, 1));
        for (int i = 0; i < 10; i++)
            pub.add(fillWithRandomData(fep, 48.20198, 13.13342, 2));


        final ArrayList<FroodyEntryPlus> pub2 = pub;
        new Thread(new Runnable() {
            @Override
            public void run() {
                for (FroodyEntryPlus entry : pub2) {
                    try {
                        new EntryPublisher(null, entry, null).start();
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

    private FroodyEntryPlus fillWithRandomData(FroodyEntryPlus template, double lat, double lng, int offsetMode) {
        FroodyEntryPlus c = FroodyEntryPlus.getCopy(template);
        if (offsetMode == 1) {
            lat += randInt(-4000, 4000) / 100000.0;
            lng += randInt(-8000, 8000) / 100000.0;
        }
        if (offsetMode == 2) {
            lat = randInt(-900000, 900000) / 10000.0;
            lng = randInt(-1800000, 1800000) / 10000.0;
        }
        c.loadGeohashFromLocation(lat, lng, 9);
        c.setCertificationType(randInt(0, 2));
        c.setDistributionType(randInt(0, 3));
        c.setEntryType(randInt(2, 35));
        c.setUserId(appSettings.getFroodyUserId());
        return c;
    }

    public int randInt(int min, int max) {
        return random.nextInt((max - min) + 1) + min;
    }


    @Override
    public void onClick(View v) {

    }

    @Override
    public String getFragmentTag() {
        return FRAGMENT_TAG;
    }

    @Override
    public boolean onBackPressed() {
        getActivity().getSupportFragmentManager().beginTransaction().remove(this).commit();
        return true;
    }
}

