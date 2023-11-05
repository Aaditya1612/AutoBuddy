  # AutoBuddy

## Problem Statement
The current landscape of personal safety solutions often requires active user interaction for implementation and use cases. This reliance on manual input can be limiting and may not adequately address situations that require immediate and autonomous responses. Instances such as walking alone at night, accidents, medical emergencies, harassment, and unfamiliar environments demand a more seamless and proactive approach. Our solution distinguishes itself by offering a hands-free and autonomous system, providing users with a comprehensive safety net while still offering manual options for diverse situations. This innovation marks a significant advancement in personal safety technology.

## Proposed Solution
Our Solution is an **autonomous app** for detecting distress situations. By the definition of being an autonomous application, our app can operate, make decisions, and perform tasks independently without external human intervention and human control. The only requirement from the user is to open the application before starting the journey to reduce the risk.

Being an autonomous system our app relies on various external triggers as listed below:

**1. Threat detection by analyzing user's voice:** Whenever we are in any danger our natural reflexes come out as loud voices and with some specific phrases in our native language. We have prepared
a multilingual(multi-language) dataset consisting of various such phrases and words, not only from the victim but also from the attacker's perspective. 

**2. Fall Detection**: Another parameter our app considers as a key trigger in the detection of distress situations by measuring the free-fall of the device.
We are aware that false triggers may happen and for that, we have implemented a 10-second prompt that a user may use to cancel the SOS.

**3. Manual SOS**:  For handling more diverse situations we have also provided an option to manually trigger the SOS with the click of a button.

### After the successful detection of a threat, our app concurrently starts the following activities:
**1. Sending SMS**: The user can add their relatives' and friends' contact details on which a customized SMS is sent with an embedded link redirecting to the victim's location on Google Maps. 
**2. E-Mail to nearby users:** All the other users of our app who are within a radius of 2 KM from the victim are sent an Email containing the location of the victim so that someone from nearby can reach out to help as soon as possible.
**3. The location of the last active SOS alert** is stored inside our database for future reference.

## Future Goals:
**1. Video Recording of incident:** We are working on implementing a method that can automatically start recording from one of the cameras of the device and send that video to the Email of emergency contacts giving a possibility of some clues and proof.
**2. Route Mapping:** The routes with more number of incidents and most frequent incidents will be highlighted on the map.
**3. Offline Detection**: We have planned to automatically use a threshold pitch value when speech detection is not possible for the detection of a threat.
**4. Bluetooth Message Sending:** In case of unavailability of the network, Bluetooth can be used to send prompts to nearby open devices.


## Screenshots of app developed till now
<table>
  <tr>
    <td><img src="https://github.com/Aaditya1612/autobuddy/assets/83654180/9687d8c9-abb2-43ae-8acc-ff5125433145"/>
</td>
  </tr>
</table>

